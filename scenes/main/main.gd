extends Control


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		GameManager.load_next_level()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
