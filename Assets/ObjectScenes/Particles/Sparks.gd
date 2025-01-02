class_name Sparks
extends CPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	pass

static func Spawn(pWorld:Node, pPostion:Vector2, pDirection:Vector2, pColor:Color = Color.WHITE) -> Sparks:
	var ret:Sparks
	var scene:PackedScene = preload("res://Assets/ObjectScenes/Particles/Sparks.tscn")
	ret = scene.instantiate()
	ret.emitting = true
	ret.position = pPostion
	ret.direction = pDirection
	ret.color = pColor
	pWorld.add_child(ret)
	return ret
