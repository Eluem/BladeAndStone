extends Projectile
class_name EyeBolt

static func Spawn(pWorld:Node, pOriginator:Node2D, pPostion:Vector2, pDirection:Vector2) -> EyeBolt:
	var ret:EyeBolt
	var scene:PackedScene = preload("res://Assets/ObjectScenes/Hazards/EyeBolt.tscn")
	ret = scene.instantiate()
	ret.originator = pOriginator
	ret.global_position = pPostion
	ret.rotation = pDirection.angle()
	#ret.transform = ret.transform.rotated(pDirection.angle())
	ret.linear_velocity = pDirection * 800
	pWorld.add_child(ret)
	return ret
