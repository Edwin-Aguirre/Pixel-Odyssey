extends CharacterBody2D


class_name Player


const GRAVITY: float = 690.0
const JUMP_VELOCITY = -300.0
const RUN_SPEED = 130.0
const MAX_FALL = 350.0
const HURT_CONSTANT_VELOCITY: Vector2 = Vector2(0, -130)
const JUMP = preload("res://assets/sound/jump.wav")
const DAMAGE = preload("res://assets/sound/damage.wav")


var _is_hurt: bool = false
var _invincible: bool = false


@export var fell_off_y: float = 750.0
@export var lives: int = 3
@export var camera_min: Vector2 = Vector2(-10000, 10000)
@export var camera_max: Vector2 = Vector2(10000, -10000)


@onready var alien_sprite_2d: Sprite2D = $AlienSprite2D
@onready var debug_label: Label = $DebugLabel
@onready var shooter: Shooter = $Shooter
@onready var sound: AudioStreamPlayer2D = $Sound
@onready var hurt_timer: Timer = $HurtTimer
@onready var player_cam: Camera2D = $PlayerCam


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_camera_limits()
	call_deferred("late_init")


func set_camera_limits() -> void:
	player_cam.limit_bottom = camera_min.y
	player_cam.limit_left = camera_min.x
	player_cam.limit_top = camera_max.y
	player_cam.limit_right = camera_max.x


func late_init() -> void:
	SignalHub.emit_on_player_hit(lives, false)


func _enter_tree() -> void:
	add_to_group(Constants.PLAYER_GROUP)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		var dir: Vector2 = Vector2.RIGHT if alien_sprite_2d.flip_h else Vector2.LEFT
		shooter.shoot(dir)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Gravity
	velocity.y += GRAVITY * delta
	
	get_input()
	
	velocity.y = clampf(velocity.y, JUMP_VELOCITY, MAX_FALL)
	
	move_and_slide()
	update_debug_label()
	fallen_off()


func play_effect(effect: AudioStream) -> void:
	sound.stop()
	sound.stream = effect
	sound.play()


func get_input() -> void:
	if _is_hurt:
		return
	
	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += JUMP_VELOCITY
		play_effect(JUMP)
	
	# Get the input direction and handle the movement.
	var direction := Input.get_axis("left", "right")
	
	# Flip the Sprite
	if direction > 0:
		alien_sprite_2d.flip_h = true
	elif direction < 0:
		alien_sprite_2d.flip_h = false
	
	# Apply movement
	if direction:
		velocity.x = direction * RUN_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, RUN_SPEED)


func update_debug_label() ->void:
	var ds: String = ""
	ds += "Floor:%s\n" % [is_on_floor()]
	ds += "V:%.1f,%.1f\n" % [velocity.x, velocity.y]
	ds += "P:%.1f,%.1f" % [global_position.x, global_position.y]
	debug_label.text = ds


func fallen_off() -> void:
	if global_position.y < fell_off_y:
		return
	reduce_lives(lives)


func go_invincible() -> void:
	if _invincible:
		return
	_invincible = true
	var tween: Tween = create_tween()
	for i in range(3):
		tween.tween_property(alien_sprite_2d, "modulate", Color("#ffffff", 0.0), 0.5)
		tween.tween_property(alien_sprite_2d, "modulate", Color("#ffffff", 1.0), 0.5)
	tween.tween_property(self, "_invincible", false, 0)


func reduce_lives(reduction: int) -> bool:
	lives -= reduction
	SignalHub.emit_on_player_hit(lives, true)
	if lives <= 0:
		set_physics_process(false)
		return false
	return true


func apply_hurt_jump() -> void:
	_is_hurt = true
	velocity = HURT_CONSTANT_VELOCITY
	hurt_timer.start()
	play_effect(DAMAGE)


func apply_hit() -> void:
	if _invincible:
		return
	
	if reduce_lives(1) == false:
		return
	
	go_invincible()
	apply_hurt_jump()


func _on_hit_box_area_entered(_area: Area2D) -> void:
	call_deferred("apply_hit")


func _on_hurt_timer_timeout() -> void:
	_is_hurt = false
