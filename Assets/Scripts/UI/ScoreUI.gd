extends Label
class_name ScoreUI

@export var prefixText:String = "Score: "

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_changed(0)
	StatTracker.score_changed.connect(score_changed)


func score_changed(pScore:int) -> void:
	text = prefixText + str(pScore)
