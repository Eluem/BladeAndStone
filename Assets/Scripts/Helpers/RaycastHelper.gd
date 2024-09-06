class_name RaycastHelper

static func RaycastAll(pSpaceState:PhysicsDirectSpaceState2D, pQuery:PhysicsRayQueryParameters2D) -> Array[Dictionary]:
	var hitResults:Array[Dictionary] = []
	var exclude:Array[RID] = pQuery.exclude
	var hitResult:Dictionary = pSpaceState.intersect_ray(pQuery)
	while(!hitResult.is_empty()):
		hitResults.append(hitResult)
		exclude.append(hitResult.rid)
		pQuery.exclude = exclude
		hitResult = pSpaceState.intersect_ray(pQuery)
	return hitResults

static func CheckLineOfSight(pSpaceState:PhysicsDirectSpaceState2D, pStartPos:Vector2, pTarget:Node2D) -> bool:
	var castHittable:RigidBodyHittable
	var query:PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(pStartPos, pTarget.global_position)
	var results:Array[Dictionary]
	results = RaycastHelper.RaycastAll(pSpaceState, query)
	for result in results:
		if(result.collider is StaticBodyHittable):
			return false
		if(result.collider is RigidBodyHittable):
			castHittable = result.collider #as RigidBodyHittable
			if(castHittable.blockLineOfSight):
				return false
			if(result.collider == pTarget):
				return true
	return false
