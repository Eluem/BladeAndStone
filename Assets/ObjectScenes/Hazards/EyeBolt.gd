extends Projectile
class_name EyeBolt

func on_hit(pHitResult:Dictionary) -> void:
	#Apply damage to hittable objects
	if(pHitResult.collider is RigidBodyHittable):
		var hittable:RigidBodyHittable = pHitResult.collider
		var hitData:HitData = HitData.new(pHitResult, linear_velocity, linear_velocity, damage, knockback)
		hittable.HandleHit(hitData)
	#Destroy self after hitting
	queue_free()

static func Spawn(pWorld:Node, pPostion:Vector2, pDirection:Vector2) -> EyeBolt:
	var ret:EyeBolt
	var scene:PackedScene = preload("res://Assets/ObjectScenes/Hazards/EyeBolt.tscn")
	ret = scene.instantiate()
	ret.global_position = pPostion
	ret.rotation = pDirection.angle()
	#ret.transform = ret.transform.rotated(pDirection.angle())
	ret.linear_velocity = pDirection * 800
	pWorld.add_child(ret)
	return ret
