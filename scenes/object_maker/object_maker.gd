extends Node2D


const OBJECT_SCENES: Dictionary[Constants.ObjectType, PackedScene] = {
	Constants.ObjectType.BULLET_PLAYER: preload("res://scenes/bullets/player_bullet.tscn"),
	Constants.ObjectType.BULLET_ENEMY: preload("res://scenes/bullets/enemy_bullet.tscn")
}


func _enter_tree() -> void:
	SignalHub.on_create_bullet.connect(on_create_bullet)


func on_create_bullet(pos: Vector2, dir: Vector2, speed: float, obj_type: Constants.ObjectType) -> void:
	if OBJECT_SCENES.has(obj_type) == false:
		return
	
	var nb: Bullet = OBJECT_SCENES[obj_type].instantiate()
	nb.setup(pos, dir, speed)
	call_deferred("add_child", nb)
	
