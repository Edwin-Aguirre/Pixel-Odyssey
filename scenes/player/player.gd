extends CharacterBody2D


class_name Player


const GRAVITY: float = 690.0
const JUMP_VELOCITY = -300.0
const RUN_SPEED = 130.0
const MAX_FALL = 350.0


@export var fell_off_y: float = 750.0


@onready var alien_sprite_2d: Sprite2D = $AlienSprite2D
@onready var debug_label: Label = $DebugLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _enter_tree() -> void:
	add_to_group(Constants.PLAYER_GROUP)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Gravity
	velocity.y += GRAVITY * delta
	
	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += JUMP_VELOCITY
	
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
	velocity.y = clampf(velocity.y, JUMP_VELOCITY, MAX_FALL)
	move_and_slide()
	
	# Update debug label
	update_debug_label()
	
	# Player dies from falling off level
	fallen_off()


func update_debug_label() ->void:
	var ds: String = ""
	ds += "Floor:%s\n" % [is_on_floor()]
	ds += "V:%.1f,%.1f\n" % [velocity.x, velocity.y]
	ds += "P:%.1f,%.1f" % [global_position.x, global_position.y]
	debug_label.text = ds


func fallen_off() -> void:
	if global_position.y > fell_off_y:
		queue_free()
