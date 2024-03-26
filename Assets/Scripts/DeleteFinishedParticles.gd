extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent:Node2D = get_parent()
	if(parent is CPUParticles2D):
		(get_parent() as CPUParticles2D).finished.connect(_finished)
	elif(parent is GPUParticles2D):
		(get_parent() as GPUParticles2D).finished.connect(_finished)

func _finished() -> void:
	get_parent().queue_free()
