extends RigidBodyHittable
class_name BossEnemyRamBeam

@onready var attackSystems:BossAttackSystems = $AttackSystems
@onready var pidJoint:PIDControllerJoint2D = $PIDControllerJoint2D
@onready var visionSensor:VisionSensor = $VisionSensor
@onready var cameraTrackTarget:Node2D = $CameraTrackTargets/CameraTrackTarget
@onready var cameraTrackTarget2:Node2D = $CameraTrackTargets/CameraTrackTarget2
@onready var cameraTrackTarget3:Node2D = $CameraTrackTargets/CameraTrackTarget3
@onready var cameraTrackTarget4:Node2D = $CameraTrackTargets/CameraTrackTarget4
@onready var cameraTrackTarget5:Node2D = $CameraTrackTargets/CameraTrackTarget5
@onready var halfHealth:int = roundi(maxHealth/2.0)

@export var isDummyMode:bool
@export var animRotationSpeedMod:float = 0

var isInPhaseTwo:bool = false
var eyes:Array[BossEnemy_Eye]
var target:Node2D:
	get:
		return target
	set(value):
		target = value
		UpdateEyesTarget(target)
var force:float = 500
var maxSpeed:float = 50 #TODO: Implement max speed
var maxFollowDist:float = 1500**2
var minFollowDist:float = 800**2
var chompAttackMaxDist:float = 1000**2
var rotationSpeed:float = 3
var searchTimer:float = 0
var searchWaitTime:float = 0.5
var bossFightManager:BossFightManager
var breaking:bool = false
var lookBehindRaycastNodes:Array[Node2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	damage_taken.connect(StatTracker.character_took_damage.bind(self))
	exploded.connect(StatTracker.character_exploded.bind(self))
	add_to_group("Enemies")
	visionSensor.object_detected.connect(object_detected)
	InitializeEyes()
	PopulateLookBehindRaycastNodes()
	#($Smasher as SmasherVisualEffect).PopulateTipPolygons(boundingPolygon)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	if(isDummyMode):
		return
	HandleDecisionMaking(delta)


func _physics_process(_delta:float) -> void:
	if(target == null || isDummyMode):
		return
	HandleBreaking()
	var moveForce:Vector2 = Vector2.ZERO
	var targetDist:float = GetDistanceToTargetSquared()
	var dirToTarget:Vector2 = GetDirectionToTarget()
	if(targetDist > maxFollowDist):
		moveForce += force * dirToTarget
	elif(targetDist < minFollowDist):
		moveForce += -force * dirToTarget
	moveForce += GetBackWallAvoidanceForce() * dirToTarget
	apply_central_force(moveForce * mass)


func _integrate_forces(state:PhysicsDirectBodyState2D) -> void:
	if(!IsTurningAllowed()):
		return
	var newTransform:Transform2D
	newTransform = state.transform.looking_at(target.global_position)
	newTransform = state.transform.rotated_local(lerp_angle(0, newTransform.get_rotation() - state.transform.get_rotation(), (rotationSpeed+animRotationSpeedMod)*state.step))
	state.transform = newTransform


func HandleDecisionMaking(pDelta:float) -> void:
	if(!isInPhaseTwo && attackSystems.CanInitiateBigAction() && health <= halfHealth):
		attackSystems.InitiatePhaseChange()


func ChompAttackLunge() -> void:
	var lungeForce:Vector2 = transform.x.normalized() * 40000
	lungeForce += -linear_velocity*mass
	apply_central_impulse(lungeForce)


func StartBreaking() -> void:
	breaking = true


func StopBreaking() -> void:
	breaking = false


func HandleBreaking() -> void:
	if(breaking):
		apply_central_force(-linear_velocity * mass)


func object_detected(pBody:Node2D) -> void:
	TargetFound(pBody)


func TargetFound(pTarget:Node2D) -> void:
	target = pTarget
	target.tree_exited.connect(TargetLost)
	can_sleep = false
	visionSensor.monitoring = false
	
	var cameraCast:CameraMultitracking = get_viewport().get_camera_2d()
	cameraCast.AddTrackTarget(self, 20)
	cameraCast.AddTrackTarget(cameraTrackTarget, 1)
	cameraCast.AddTrackTarget(cameraTrackTarget2, 1)
	cameraCast.AddTrackTarget(cameraTrackTarget3, 1)
	cameraCast.AddTrackTarget(cameraTrackTarget4, 1)
	cameraCast.AddTrackTarget(cameraTrackTarget5, 1)


func TargetLost() -> void:
	#attackSystems.TargetLost()
	visionSensor.monitoring = true
	can_sleep = true
	target.tree_exited.disconnect(TargetLost)
	target = null
	
	var viewPort:Viewport = get_viewport()
	if(viewPort):
		var cameraCast:CameraMultitracking = get_viewport().get_camera_2d()
		cameraCast.RemoveTrackTarget(self)
		cameraCast.RemoveTrackTarget(cameraTrackTarget)
		cameraCast.RemoveTrackTarget(cameraTrackTarget2)
		cameraCast.RemoveTrackTarget(cameraTrackTarget3)
		cameraCast.RemoveTrackTarget(cameraTrackTarget4)
		cameraCast.RemoveTrackTarget(cameraTrackTarget5)


func IsTurningAllowed() -> bool:
	return target != null && !isDummyMode && !attackSystems.IsChompAttackActive()


func HandleHit(pHitData:HitData) -> void:
	super.HandleHit(pHitData)
	if(pHitData.hitOwner is Golem && !target):
		TargetFound(pHitData.hitOwner)


func Die(pHitOwner:Node2D, pDir:Vector2, pForce:float) -> void:
	BossHeart.Spawn(self).boss_heart_collected.connect(bossFightManager.boss_heart_collected.unbind(1))
	super.Die(pHitOwner, pDir, pForce)


func InitializeEyes() -> void:
	eyes = []
	for child:Node in $AttackSystems.get_children():
		if(child is BossEnemy_Eye):
			eyes.append(child)


func UpdateEyesTarget(pTarget:Node2D) -> void:
	for eye:BossEnemy_Eye in eyes:
		eye.SetTarget(pTarget)


func IntroScream() -> void:
	attackSystems.Scream()


func PopulateLookBehindRaycastNodes() -> void:
	lookBehindRaycastNodes = []
	lookBehindRaycastNodes.append($VisionSensor/LookBehindRaycastNodeLeft)
	lookBehindRaycastNodes.append($VisionSensor/LookBehindRaycastNodeRight)


#Gets the nearest distance to the boss from any of the look behind raycast nodes
func GetDistanceToBackWall() -> float:
	var ret:float = -1
	var query:PhysicsRayQueryParameters2D
	var hitResults:Dictionary
	var blockerCast:Dictionary
	var positionCast:Vector2
	var tempDist:float
	for node:Node2D in lookBehindRaycastNodes:
		query = PhysicsRayQueryParameters2D.create(node.global_position, node.transform.x * 5000)
		hitResults = RaycastHelper.RaycastAllUntilBlocker(get_world_2d().direct_space_state, query)
		blockerCast = hitResults.blocker
		if(!blockerCast.is_empty()):
			positionCast = blockerCast.position
			tempDist = (positionCast - node.global_position).length()
			if(tempDist < ret || ret == -1):
				ret = tempDist
	return ret


func GetBackWallAvoidanceForce() -> float:
	var backwallDist:float = GetDistanceToBackWall()
	if(backwallDist == -1 || backwallDist > 2000):
		return 0
	return 1000 * (backwallDist/2000)


func GetDistanceToTarget() -> float:
	return GetVectorToTarget().length()


func GetDistanceToTargetSquared() -> float:
	return GetVectorToTarget().length_squared()


func GetVectorToTarget() -> Vector2:
	return target.global_position - global_position


func GetDirectionToTarget() -> Vector2:
	return GetVectorToTarget().normalized()


func ActivatePhaseTwo() -> void:
	isInPhaseTwo = true
