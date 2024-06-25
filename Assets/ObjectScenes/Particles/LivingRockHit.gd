class_name LivingRockHit
extends GPUParticles2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

static func Spawn(pWorld:Node, pPostion:Vector2, pDirection:Vector2) -> LivingRockHit:
	var ret:LivingRockHit
	var scene:PackedScene = preload("res://Assets/ObjectScenes/Particles/LivingRockHit.tscn")
	ret = scene.instantiate()
	ret.emitting = true
	ret.global_position = pPostion
	ret.transform = ret.transform.rotated_local(pDirection.angle())
	pWorld.add_child(ret)
	return ret
