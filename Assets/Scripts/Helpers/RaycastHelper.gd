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
