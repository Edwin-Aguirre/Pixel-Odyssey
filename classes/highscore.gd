extends Resource

class_name HighScore

@export var score: int = 0
@export var date_scored: String = PixelUtils.formatted_dt()


func _init(_score: int = 0, _date: String = PixelUtils.formatted_dt()) -> void:
	score = _score
	date_scored = _date
