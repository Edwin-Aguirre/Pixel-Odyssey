extends Area2D


class_name Bullet


@onready var sprite_2d: Sprite2D = $Sprite2D


var _direction: Vector2 = Vector2(50,-50)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += _direction * delta
	
	# Flip the Sprite
	if _direction > Vector2.RIGHT:
		sprite_2d.flip_h = false
	elif _direction < Vector2.LEFT:
		sprite_2d.flip_h = true


func setup(pos: Vector2, dir: Vector2, speed: float) -> void:
	_direction = dir.normalized() * speed
	global_position = pos


func _on_area_entered(_area: Area2D) -> void:
	queue_free()
