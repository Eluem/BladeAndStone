extends Projectile
class_name EyeTurretBolt

static func Spawn(pWorld:Node, pOriginator:Node2D, pPostion:Vector2, pDirection:Vector2) -> EyeTurretBolt:
	var ret:EyeTurretBolt
	var scene:PackedScene = preload("res://Assets/ObjectScenes/Hazards/EyeTurretBolt.tscn")
	ret = scene.instantiate()
	ret.originator = pOriginator
	ret.global_position = pPostion
	ret.rotation = pDirection.angle()
	#ret.transform = ret.transform.rotated(pDirection.angle())
	ret.linear_velocity = pDirection * 800
	pWorld.add_child(ret)
	return ret
