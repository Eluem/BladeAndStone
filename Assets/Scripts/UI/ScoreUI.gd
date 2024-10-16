extends Label
class_name ScoreUI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	StatTracker.score_changed.connect(score_changed)


func score_changed(pScore:int) -> void:
	text = str(pScore)
