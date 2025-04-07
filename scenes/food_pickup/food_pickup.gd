extends Area2D


@export var points: int = 2


@onready var anim: AnimatedSprite2D = $Anim


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ln: Array[String] = []
	for an_name in anim.sprite_frames.get_animation_names():
		ln.push_back(an_name)
	anim.animation = ln.pick_random()
	anim.play()


func _on_area_entered(_area: Area2D) -> void:
	queue_free()
