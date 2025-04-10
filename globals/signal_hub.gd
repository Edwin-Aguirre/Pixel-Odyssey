extends Node


signal on_create_bullet(pos: Vector2, dir: Vector2, speed: float, obj_type: Constants.ObjectType)
signal on_create_object(pos: Vector2, obj_type: Constants.ObjectType)
signal on_scored(points: int)


func emit_on_create_bullet(pos: Vector2, dir: Vector2, speed: float, obj_type: Constants.ObjectType) -> void:
	on_create_bullet.emit(pos, dir, speed, obj_type)


func emit_on_create_object(pos: Vector2, obj_type: Constants.ObjectType) -> void:
	on_create_object.emit(pos, obj_type)


func emit_on_scored(points: int) -> void:
	on_scored.emit(points)
