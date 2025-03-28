extends TrackingProjectile
class_name Boss_EyeBolt_Small

static func Spawn(pWorld:Node, pOriginator:Node2D, pPostion:Vector2, pDirection:Vector2, pTarget:Node2D = null) -> Boss_EyeBolt_Small:
	var ret:Boss_EyeBolt_Small
	var scene:PackedScene = preload("res://Assets/ObjectScenes/Hazards/Boss_EyeBolt_Small.tscn")
	ret = scene.instantiate()
	ret.originator = pOriginator
	ret.global_position = pPostion
	ret.global_rotation = pDirection.angle()
	#ret.transform = ret.transform.rotated(pDirection.angle())
	ret.linear_velocity = pDirection * 800
	ret.target = pTarget
	pWorld.add_child(ret)
	return ret
