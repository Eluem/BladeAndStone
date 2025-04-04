#Note: I'd like to make all of this much more modularized.. right now I have multiple systems for hit detection
#but they're not all well standardized. Like like to have one set of tools to handle this, but
#it's a bit difficult because there's no interfaces to work with and I'd need one for
#Rigidbodies and one for StaticBodies, and another for Node2D hazards..
#For my next project, I'd like to do this all a bit better
extends HazardStatic
class_name BossEnemy_EyeBeamProjector
@onready var beamLine:Line2D = $BeamLine

@export var enabled:bool = true
@export var fullDamage:int = 30
@export var maxBeamLength:float = 5000
@export var minBeamLength:float = 10
@export var beamRaycastTotalWidth:float = 340:
	get:
		return beamRaycastTotalWidth
	set(value):
		if(beamRaycastTotalWidth != value):
			beamRaycastTotalWidth = value
			UpdateBeamHitDetectorData()
##Max distance between beam raycast lines, any object smaller than this could slip through
##Note: Perhaps it would be better to use a shape cast?
@export var beamRaycastMaxSeparation:float = 30:
	get:
		return beamRaycastMaxSeparation
	set(value):
		if(beamRaycastMaxSeparation != value):
			beamRaycastMaxSeparation = value
			UpdateBeamHitDetectorData()
@export var fullHitCooldownTime:float = 0.2
@export var chipHitCooldownTime:float = 0.1
@export var beamHitVFX:BeamHitVFX
var originatorRID:RID
var fullHitRIDs:Array[RID] #RIDs to ignore because they were already hit this attack
var fullHitRIDResetTimers:Array[float] #Time left to ignore hit per RID
var chipHitRIDs:Array[RID] #RIDs to ignore because they were already hit this attack
var chipHitRIDResetTimers:Array[float] #Time left to ignore hit per RID
var raycastStartPosOffsets:Array[float]

func _ready() -> void:
	if(originator is PhysicsBody2D):
		originatorRID = (originator as PhysicsBody2D).get_rid()
	UpdateBeamHitDetectorData()


func _process(delta:float) -> void:
	if(!enabled):
		return
	HandleHitRIDResetTimers(delta)
	Firing()


func Firing() -> void:
	HandleBeamHit()


func HandleBeamHit() -> void:
	var beamHitData:Dictionary = BeamHitCheck()
	var newBeamLength:float = maxBeamLength
	if(beamHitData.is_empty()):
		UpdateBeamLength(-1)
		return
	var blocker:Dictionary = beamHitData.blocker
	if(!blocker.is_empty()):
		newBeamLength = blocker.distance
	UpdateBeamLength(newBeamLength)
	var nearestTarget:Dictionary = beamHitData.nearestTarget
	if(!nearestTarget.is_empty()):
		var nearestTargetPosCast:Vector2 = nearestTarget.position
		beamHitVFX.Update(global_position + (nearestTargetPosCast - global_position).project(global_transform.x), global_transform.x)


func BeamHitCheck() -> Dictionary:
	var beamHitData:Dictionary
	var blocker:Dictionary
	var nearestTarget:Dictionary
	var hitResults:Array[Dictionary]
	var query:PhysicsRayQueryParameters2D
	var exclude:Array[RID] = [originatorRID]
	#exclude.append_array(hitRIDs)
	var rayStartPos:Vector2
	var rayEndPos:Vector2
	var perpendicular:Vector2 = Geometry2DHelper.GetPerpendicular(global_transform.x)
	var raycastLength:float = maxBeamLength
	var newData:Dictionary
	var newBlocker:Dictionary
	var newHitResults:Array[Dictionary]
	var blockerPosCast:Vector2
	var nextTargetPosCast:Vector2
	var nextTargetDistCheck:float
	var currNearestTargetDist:float = maxBeamLength
	for offset:float in raycastStartPosOffsets:
		rayStartPos = global_position + perpendicular * offset
		rayEndPos = rayStartPos + (global_transform.x * raycastLength)
		#DebugLine.DrawLine(get_tree().current_scene, rayStartPos, rayEndPos, Color.RED, 1)
		query = PhysicsRayQueryParameters2D.create(rayStartPos, rayEndPos)
		query.exclude = exclude
		newData = RaycastHelper.RaycastAllUntilBlocker(get_world_2d().direct_space_state, query)
		if(!newData.is_empty()):
			newBlocker = newData.blocker
			if(!newBlocker.is_empty()):
				blockerPosCast = newBlocker.position
				newBlocker.distance = (blockerPosCast - rayStartPos).length()
				if(newBlocker.distance < raycastLength):
					raycastLength = newBlocker.distance
					blocker = newBlocker
			newHitResults = newData.hitResults
			for hitResult:Dictionary in newHitResults:
				nextTargetPosCast = hitResult.position
				nextTargetDistCheck = (nextTargetPosCast - rayStartPos).length()
				if(nextTargetDistCheck < currNearestTargetDist):
					currNearestTargetDist = nextTargetDistCheck
					nearestTarget = hitResult
				HandleHit(hitResult)
				exclude.append(hitResult.rid)
			hitResults.append_array(newHitResults)
	beamHitData.blocker = blocker
	beamHitData.nearestTarget = nearestTarget
	beamHitData.hitResults = hitResults
	return beamHitData


func UpdateBeamLength(pLength:float) -> void:
	pLength = max(pLength, minBeamLength)
	beamLine.points[0].x = pLength - beamLine.points[1].x


func UpdateBeamHitDetectorData() -> void:
	raycastStartPosOffsets = [0]
	var raycastCount:int = ceili(beamRaycastTotalWidth / beamRaycastMaxSeparation)
	var spacing:float
	if(raycastCount < 2):
		raycastCount = 2
	if(raycastCount%2 == 1):
		raycastCount-=1
	spacing = beamRaycastTotalWidth / raycastCount
	raycastCount /= 2
	
	for i:int in range(1, raycastCount+1):
		raycastStartPosOffsets.append(i * spacing)
		raycastStartPosOffsets.append(-i * spacing)


func HandleHit(pHitResult:Dictionary) -> void:
	pHitResult["direction"] = global_transform.x
	var alreadyHitIndex:int
	alreadyHitIndex = fullHitRIDs.find(pHitResult.rid)
	if(alreadyHitIndex == -1):
		pHitResult["overrideDamage"] = fullDamage
		fullHitRIDs.append(pHitResult.rid)
		fullHitRIDResetTimers.append(fullHitCooldownTime)
	elif(!chipHitRIDs.has(pHitResult.rid)):
		chipHitRIDs.append(pHitResult.rid)
		chipHitRIDResetTimers.append(chipHitCooldownTime)
		fullHitRIDResetTimers[alreadyHitIndex] = fullHitCooldownTime
	else:
		return
	on_hit(pHitResult)
	#var hitResultPosCast:Vector2 = pHitResult.position

func HandleHitRIDResetTimers(pDelta:float) -> void:
	HandleFullHitRIDResetTimers(pDelta)
	HandleChipHitRIDResetTimers(pDelta)


func HandleChipHitRIDResetTimers(pDelta:float) -> void:
	var timersCompleted:Array[int] = []
	for i:int in range(chipHitRIDResetTimers.size()):
		chipHitRIDResetTimers[i] -= pDelta
		if(chipHitRIDResetTimers[i] <= 0):
			timersCompleted.append(i)
	timersCompleted.reverse()
	for index:int in timersCompleted:
		chipHitRIDResetTimers.remove_at(index)
		chipHitRIDs.remove_at(index)


func HandleFullHitRIDResetTimers(pDelta:float) -> void:
	var timersCompleted:Array[int] = []
	for i:int in range(fullHitRIDResetTimers.size()):
		fullHitRIDResetTimers[i] -= pDelta
		if(fullHitRIDResetTimers[i] <= 0):
			timersCompleted.append(i)
	timersCompleted.reverse()
	for index:int in timersCompleted:
		fullHitRIDResetTimers.remove_at(index)
		fullHitRIDs.remove_at(index)


func StartFiring() -> void:
	enabled = true


func StopFiring() -> void:
	enabled = false
	fullHitRIDs.clear()
	fullHitRIDResetTimers.clear()
	chipHitRIDs.clear()
	chipHitRIDResetTimers.clear()
