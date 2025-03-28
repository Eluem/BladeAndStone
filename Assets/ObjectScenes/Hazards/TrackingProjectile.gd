extends Projectile
class_name TrackingProjectile

enum TrackState
{
	 InitialDumbFire
	,InitialPath
	#,SearchingForTarget TODO: Implement these maybe in the future
	#,AttemptingLockOnTarget
	,TrackingTarget
	,NotTracking
	,CancelTracking
}

@onready var pidJoint:PIDControllerJoint2D = $PIDControllerJoint2D

##Speed that the projectile will try to maintain after navigation systems kick in
@export var speed:float = 500
##Duration that the projectile cruises on its initial vector before navigation systems kick in (-1 means indefinite)
@export var initialDumbFireDuration:float = 1
##Maximum time the projectile will spend following the initial path (-1 means indefinite)
@export var initialPathDuration:float = -1
##Distance that the projectile must be from an initial path node to move on to the next one
##[br]NOTE:This concept could be optimized further by taking into account matching the angle of the node
@export var initialPathNodeDist:float = 100:
	get:
		return initialPathNodeDist
	set(value):
		if(initialPathNodeDist != value):
			initialPathNodeDist = value
			initialPathNodeDistSqred = initialPathNodeDist**2
var initialPathNodeDistSqred:float = initialPathNodeDist**2:
	get:
		return initialPathNodeDistSqred
	set(value):
		initialPathNodeDistSqred = value
		initialPathNodeDist = sqrt(initialPathNodeDist)
##How long the tracking phase lasts once it's started (-1 means indefinite)
@export var trackingDuration:float = -1
##Duration until projectile clearst he list of objects it can't hit (-1 means indefinite)
##[br](Meant to make it possbile to send projectiles back to attacker, but will also cause multihits in some rare cases)
@export var selfDamageDelay:float = -1
##Track state to start reducing the selfDamageDelay timer
@export var selfDamageDelayStateStart:TrackState
##If the target is ever closer in distance or angle, the path following step ends early
@export var favorTargetOverPath:bool = true
##Angle (in degrees) to the target at which the path is ignored automatically
##[br](Only applies if favorTargetOverPath is true)
@export var targetForceBreakawayAngle:float = 0:
	get:
		return targetForceBreakawayAngle
	set(value):
		if(targetForceBreakawayAngle != value):
			targetForceBreakawayAngle = value
			targetForceBreakawayAngleRad = deg_to_rad(targetForceBreakawayAngle)
var targetForceBreakawayAngleRad:float = deg_to_rad(targetForceBreakawayAngle):
	get:
		return targetForceBreakawayAngleRad
	set(value):
		if(targetForceBreakawayAngleRad != value):
			targetForceBreakawayAngleRad = value
			targetForceBreakawayAngle = rad_to_deg(targetForceBreakawayAngleRad)
##If true, won't break path to favor target if a raycast towards the target cuts through
##the originator's collider
@export var avoidOriginatorDuringPathBreak:bool = true
@export var initialTargetLockMaxAngle:float = 120:
	get:
		return initialTargetLockMaxAngle
	set(value):
		if(initialTargetLockMaxAngle != value):
			initialTargetLockMaxAngle = value
			initialTargetLockMaxAngleRad = deg_to_rad(initialTargetLockMaxAngle)
var initialTargetLockMaxAngleRad:float = deg_to_rad(initialTargetLockMaxAngle):
	get:
		return initialTargetLockMaxAngleRad
	set(value):
		if(initialTargetLockMaxAngleRad != value):
			initialTargetLockMaxAngleRad = value
			initialTargetLockMaxAngle = rad_to_deg(initialTargetLockMaxAngleRad)
##Target that will be used for tracking and navigation
@export var target:Node2D
##Initial path nodes that the projectile will follow during the InitialPath TrackState
@export var initialPath:Array[Node2D]
##Angle the projectile needs to be off by to force a lock break (-1 disables lock break)
@export var dodgeLockBreakAngle:float = -1:
	get:
		return dodgeLockBreakAngle
	set(value):
		if(dodgeLockBreakAngle != value):
			dodgeLockBreakAngle = value
			dodgeLockBreakAngleRad = deg_to_rad(dodgeLockBreakAngle)
var dodgeLockBreakAngleRad:float = deg_to_rad(dodgeLockBreakAngle):
	get:
		return dodgeLockBreakAngleRad
	set(value):
		if(dodgeLockBreakAngleRad != value):
			dodgeLockBreakAngleRad = value
			dodgeLockBreakAngle = rad_to_deg(dodgeLockBreakAngleRad)
##Minimum distance for dodge lock break angle to work (-1 causes a lock break at any distance)
@export var dodgeLockBreakDist:float = 100:
	get:
		return dodgeLockBreakDist
	set(value):
		if(dodgeLockBreakDist != value):
			dodgeLockBreakDist = value
			dodgeLockBreakDistSqred = dodgeLockBreakDist**2
var dodgeLockBreakDistSqred:float = dodgeLockBreakDist**2:
	get:
		return dodgeLockBreakDistSqred
	set(value):
		dodgeLockBreakDistSqred = value
		dodgeLockBreakDist = sqrt(dodgeLockBreakDistSqred)

var trackState:TrackState:
	get:
		return trackState
	set(value):
		if(trackState != value):
			trackState = value
			HandleTrackStateChange()


func _ready() -> void:
	super._ready()
	UpdateTrackState()


func _process(delta:float) -> void:
	super._process(delta)
	HandleTimers(delta)


func _physics_process(_delta:float) -> void:
	HandleNavigation()


func _integrate_forces(state:PhysicsDirectBodyState2D) -> void:
	var xform:Transform2D = state.get_transform()
	xform.x = Vector2(1, 0)
	xform.y = Vector2(0, 1)
	xform = xform.rotated_local(linear_velocity.angle())
	state.set_transform(xform)


#Determines the track state based on the current information
#For all of these timers, -1 means indefinite. There's a check in the timer updates that
#makes sure it'll never go from > 0 to < 0
func UpdateTrackState() -> void:
	if(initialDumbFireDuration > 0 || initialDumbFireDuration == -1):
		trackState = TrackState.InitialDumbFire
	elif((initialPathDuration == -1 || initialPathDuration > 0) && initialPath.size() > 0):
		trackState = TrackState.InitialPath
	elif((trackingDuration == -1 || trackingDuration > 0) && is_instance_valid(target) && abs(get_angle_to(target.global_position)) <= initialTargetLockMaxAngleRad):
		trackState = TrackState.TrackingTarget
	else:
		trackState = TrackState.NotTracking


#Updates all the timers
func HandleTimers(pDelta:float) -> void:
	HandleSelfDamageDelay(pDelta)
	HandleInitialDumbFireDuration(pDelta)
	HandleInitialPathDuration(pDelta)
	HandleTrackingDuration(pDelta)


#Determines the next target position and calls UpdateNavInfo with that position
func HandleNavigation() -> void:
	if(trackState == TrackState.InitialDumbFire || trackState == TrackState.NotTracking):
		return
	var targetPos:Vector2
	if(trackState == TrackState.InitialPath):
		targetPos = GetInitialPathNextPos()
	elif(trackState == TrackState.TrackingTarget):
		if(is_instance_valid(target)):
			DodgeLockBreakCheck()
			targetPos = target.global_position
		else:
			trackState = TrackState.NotTracking
			return
	pidJoint.targetPos = targetPos
	pidJoint.targetVel = (targetPos-global_position).normalized() * speed


#Clear collision exceptions after self damage delay ends (Allows player to guide attacks back into boss)
func HandleSelfDamageDelay(pDelta:float) -> void:
	if(selfDamageDelay > 0 && trackState >= selfDamageDelayStateStart):
		selfDamageDelay -= pDelta
		if(selfDamageDelay <= 0):
			selfDamageDelay = 0
			collider.ClearExceptions()


#Enable tracking after track delay ends
func HandleInitialDumbFireDuration(pDelta:float) -> void:
	if(trackState == TrackState.InitialDumbFire && initialDumbFireDuration > 0):
		initialDumbFireDuration -= pDelta
		if(initialDumbFireDuration <= 0):
			initialDumbFireDuration = 0
			UpdateTrackState()


func HandleInitialPathDuration(pDelta:float) -> void:
	if(trackState == TrackState.InitialPath && initialPathDuration > 0):
		initialPathDuration -= pDelta
		if(initialPathDuration <= 0):
			initialPathDuration = 0
			UpdateTrackState()


#Disable tracking after track duration ends, only start counting if currently tracking
func HandleTrackingDuration(pDelta:float) -> void:
	if(trackState == TrackState.TrackingTarget && trackingDuration > 0):
		trackingDuration -= pDelta
		if(trackingDuration <= 0):
			trackingDuration = 0
			UpdateTrackState()


func PopulateInitialPathWithNodes(pNodes:Array[Node]) -> void:
	initialPath = []
	for node:Node2D in pNodes:
		initialPath.append(node)
	UpdateTrackState()


func GetInitialPathNextPos() -> Vector2:
	#Initial validation check
	if(initialPath.size() == 0):
		UpdateTrackState()
		if(trackState == TrackState.TrackingTarget):
			return target.global_position
		else:
			return Vector2.ZERO
	if(!is_instance_valid(initialPath[0])):
		trackState = TrackState.CancelTracking
	var retPos:Vector2
	var nextPathPos:Vector2 = initialPath[0].global_position
	var nextPathPosDistSqred:float = (nextPathPos - global_position).length_squared()
	#var nextPathAngleDist:float = abs(angle_difference(global_rotation, global_transform.looking_at(nextPathPos).get_rotation())) #abs(angle_difference(global_rotation, get_angle_to(nextPathPos)))
	var nextPathAngleTo:float = abs(get_angle_to(nextPathPos))
	retPos = nextPathPos
	if(nextPathPosDistSqred <= initialPathNodeDistSqred):
		initialPath.pop_front()
		UpdateTrackState()
	if(is_instance_valid(target)):
		if(trackState == TrackState.TrackingTarget):
			retPos = target.global_position
		elif(favorTargetOverPath):
			var targetPosDistSqred:float = (target.global_position - global_position).length_squared()
			#var targetAngleDist:float = abs(angle_difference(global_rotation, global_transform.looking_at(target.global_position).get_rotation())) #abs(angle_difference(global_rotation, get_angle_to(target.global_position)))
			var targetAngleTo:float = abs(get_angle_to(target.global_position))
			if(targetPosDistSqred <= nextPathPosDistSqred || targetAngleTo < nextPathAngleTo || targetAngleTo < targetForceBreakawayAngleRad):
				if(!DoesPathToTargetIntersectOriginator()):
					retPos = target.global_position
					initialPath.clear()
					UpdateTrackState()
	return retPos


func HandleTrackStateChange() -> void:
	match trackState:
		TrackState.InitialDumbFire:
			pidJoint.enabled = false
		TrackState.InitialPath:
			pidJoint.enabled = true
		TrackState.TrackingTarget:
			pidJoint.enabled = true
		TrackState.NotTracking:
			pidJoint.enabled = false
		TrackState.CancelTracking:
			trackingDuration = 0
			target = null
			pidJoint.enabled = false


func DodgeLockBreakCheck() -> void:
	if(dodgeLockBreakDist == -1 || dodgeLockBreakDistSqred >= (global_position - target.global_position).length_squared()):
		if(abs(get_angle_to(target.global_position)) >= dodgeLockBreakAngleRad):
			trackingDuration = 0
			UpdateTrackState()


func DoesPathToTargetIntersectOriginator() -> bool:
	var hitResult:Dictionary
	hitResult = RaycastHelper.RaycastToRID(get_world_2d().direct_space_state, originatorRID, global_position, target.global_position)
	return !hitResult.is_empty()
