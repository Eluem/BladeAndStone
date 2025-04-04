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
@export var wallAvoidMaxDist:float = 2000

var isInPhaseTwo:bool = false
var eyes:Array[BossEnemy_Eye]
var target:Node2D:
	get:
		return target
	set(value):
		target = value
		UpdateEyesTarget(target)
var moveForwardForce:float = 700
var moveReverseForce:float = 1000
var wallAvoidForce:float = 800
var maxForwardSpeed:float = 1000**2
var maxReverseSpeed:float = 600**2
var maxFollowDist:float = 1200**2
var minFollowDist:float = 1000**2
var chompAttackMaxDist:float = 1000**2
var frontEyeBlasterMinDist:float = 800**2
var wallBugOutDist:float = 200**2
var rotationSpeed:float = 3
var bossFightManager:BossFightManager
var breaking:bool = false
var wallAvoidRaycastNodes:Array[Node2D]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	damage_taken.connect(StatTracker.character_took_damage.bind(self))
	exploded.connect(StatTracker.character_exploded.bind(self))
	add_to_group("Enemies")
	visionSensor.object_detected.connect(object_detected)
	InitializeEyes()
	PopulateWallAvoidRaycastNodes()
	#($Smasher as SmasherVisualEffect).PopulateTipPolygons(boundingPolygon)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	if(isDummyMode):
		return
	HandleDecisionMaking(delta)


func _physics_process(_delta:float) -> void:
	HandleBreaking()
	if(!CanMove()):
		return
	var moveForce:Vector2 = Vector2.ZERO
	var targetDist:float = GetDistanceToTargetSquared()
	var dirToTarget:Vector2 = GetDirectionToTarget()
	var speedTowardsTarget:float = linear_velocity.dot(dirToTarget)
	speedTowardsTarget = sign(speedTowardsTarget) * speedTowardsTarget**2
	if(targetDist > maxFollowDist && speedTowardsTarget < maxForwardSpeed):
		moveForce += moveForwardForce * dirToTarget
	elif(targetDist < minFollowDist && -speedTowardsTarget < maxReverseSpeed):
		moveForce += -moveReverseForce * dirToTarget
	moveForce += GetWallAvoidVector() * wallAvoidForce
	DebugLine.DrawLine(get_tree().current_scene, global_position, global_position + moveForce, Color.BLUE, 0.1)
	apply_central_force(moveForce * mass)


func _integrate_forces(state:PhysicsDirectBodyState2D) -> void:
	if(!CanTurn()):
		return
	var effectiveRotationSpeed:float
	var newTransform:Transform2D
	var targetRotation:float
	if(attackSystems.IsBeamActive()):
		effectiveRotationSpeed = attackSystems.beamRotationSpeed
		targetRotation = 1
	else:
		effectiveRotationSpeed = rotationSpeed+animRotationSpeedMod;
		newTransform = state.transform.looking_at(target.global_position)
		targetRotation = newTransform.get_rotation() - state.transform.get_rotation()
	effectiveRotationSpeed *= state.step
	newTransform = state.transform.rotated_local(lerp_angle(0, targetRotation, effectiveRotationSpeed))
	state.transform = newTransform


func HandleDecisionMaking(pDelta:float) -> void:
	var canInitiateBigAction:bool = attackSystems.CanInitiateBigAction()
	if(!isInPhaseTwo && canInitiateBigAction && health <= halfHealth):
		attackSystems.InitiatePhaseChange()
	
	if(target == null && attackSystems.MouthNotInUse()):
		attackSystems.Scream()
		isDummyMode = true


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
	
	#Remove self from camera tracking if target player is lost
	#var viewPort:Viewport = get_viewport()
	#if(viewPort):
		#var cameraCast:CameraMultitracking = get_viewport().get_camera_2d()
		#cameraCast.RemoveTrackTarget(self)
		#cameraCast.RemoveTrackTarget(cameraTrackTarget)
		#cameraCast.RemoveTrackTarget(cameraTrackTarget2)
		#cameraCast.RemoveTrackTarget(cameraTrackTarget3)
		#cameraCast.RemoveTrackTarget(cameraTrackTarget4)
		#cameraCast.RemoveTrackTarget(cameraTrackTarget5)


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


func PopulateWallAvoidRaycastNodes() -> void:
	wallAvoidRaycastNodes = []
	wallAvoidRaycastNodes.append($VisionSensor/WallAvoidRaycastNodeLeft)
	wallAvoidRaycastNodes.append($VisionSensor/WallAvoidRaycastNodeRight)
	wallAvoidRaycastNodes.append($VisionSensor/WallAvoidRaycastNodeBackLeft)
	wallAvoidRaycastNodes.append($VisionSensor/WallAvoidRaycastNodeBackRight)


#Gets the combined vector of near by walls to determine what direction to move in to avoid all of them
func GetWallAvoidVector() -> Vector2:
	var ret:Vector2 = Vector2.ZERO
	var query:PhysicsRayQueryParameters2D
	var hitResults:Dictionary
	var blockerCast:Dictionary
	var positionCast:Vector2
	for node:Node2D in wallAvoidRaycastNodes:
		query = PhysicsRayQueryParameters2D.create(node.global_position, node.global_position + node.global_transform.x * wallAvoidMaxDist)
		hitResults = RaycastHelper.RaycastAllUntilBlocker(get_world_2d().direct_space_state, query)
		blockerCast = hitResults.blocker
		if(!blockerCast.is_empty()):
			positionCast = blockerCast.position
			ret += (node.global_position - positionCast)
	ret = ret.normalized() * ((wallAvoidMaxDist - ret.length()) / wallAvoidMaxDist)
	return ret


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


func CanMove() -> bool:
	if(target == null):
		return false
	if(isDummyMode):
		return false
	if(attackSystems.IsChompAttackActive()):
		return false
	if(attackSystems.IsChompAttackEnding()):
		return false
	if(attackSystems.IsBeamActive()):
		return false
	return true


func CanTurn() -> bool:
	if(attackSystems.IsBeamActive()):
		return true
	if(target == null):
		return false
	if(isDummyMode):
		return false
	if(attackSystems.IsChompAttackActive()):
		return false
	#if(attackSystems.IsBeamActive()):
		#return false
	return true 
