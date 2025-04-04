extends Node2D
class_name TopLevelMovementTracker
@export var target:Node2D

func _ready() -> void:
	top_level = true
	if(target == null):
		target = get_parent()
	reparent.bind(get_tree().current_scene).call_deferred()

func _process(_delta:float) -> void:
	if(target == null):
		return
	global_position = target.position
