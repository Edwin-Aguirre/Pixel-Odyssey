extends CharacterBody2D


class_name Player


const GRAVITY: float = 690.0
const JUMP_VELOCITY = -300.0
const RUN_SPEED = 130.0


@onready var alien_sprite_2d: Sprite2D = $AlienSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
	move_and_slide()
