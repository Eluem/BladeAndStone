class_name RaycastHelper


static func RaycastToRID(pSpaceState:PhysicsDirectSpaceState2D, pRID:RID, pStartPos:Vector2, pEndPos:Vector2) -> Dictionary:
	if(!pRID.is_valid()):
		return {}
	var query:PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(pStartPos, pEndPos)
	var exclude:Array[RID] = []
	var hitResult:Dictionary = pSpaceState.intersect_ray(query)
	while(!hitResult.is_empty() && hitResult.rid != pRID):
		exclude.append(hitResult.rid)
		query.exclude = exclude
		hitResult = pSpaceState.intersect_ray(query)
	return hitResult


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


##Returns a dictionary containing blocker (a raycast hit result dictionary) and hitResults (an array of raycast hit result dictionaries)
##if blocker is empty, it means no blocker was hit
static func RaycastAllUntilBlocker(pSpaceState:PhysicsDirectSpaceState2D, pQuery:PhysicsRayQueryParameters2D) -> Dictionary:
	var raycastResults:Dictionary
	
	var blocker:Dictionary
	var hitResults:Array[Dictionary] = []
	var exclude:Array[RID] = pQuery.exclude
	var hitResult:Dictionary = pSpaceState.intersect_ray(pQuery)
	var castHittable:RigidBodyHittable
	while(!hitResult.is_empty()):
		if(hitResult.collider is StaticBodyHittable):
			blocker = hitResult
			break
		if(hitResult.collider is RigidBodyHittable):
			castHittable = hitResult.collider
			if(castHittable.blockLineOfSight):
				blocker = hitResult
				break
		hitResults.append(hitResult)
		exclude.append(hitResult.rid)
		pQuery.exclude = exclude
		hitResult = pSpaceState.intersect_ray(pQuery)
	
	raycastResults.blocker = blocker
	raycastResults.hitResults = hitResults
	
	return raycastResults
