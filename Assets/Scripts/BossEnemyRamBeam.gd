extends RigidBodyHittable
class_name BossEnemyRamBeam

@onready var cameraTrackTarget:Node2D = $MainSprite/CameraTrackTarget
@onready var cameraTrackTarget2:Node2D = $MainSprite/CameraTrackTarget2
@onready var cameraTrackTarget3:Node2D = $MainSprite/CameraTrackTarget3
@onready var cameraTrackTarget4:Node2D = $MainSprite/CameraTrackTarget4
@onready var cameraTrackTarget5:Node2D = $MainSprite/CameraTrackTarget5


var target:Node2D
var force:float = 500
var maxSpeed:float = 50 #TODO: Implement max speed
var maxFollowDist:float = 500**2
var minFollowDistRange:Vector2 = Vector2(400**2, maxFollowDist)
var attackStartMaxDist:float = 600**2
var rotationSpeed:float = 3
var attackChargeWaitTime:float = 4
var attackChargeWarningWaitTime:float = 3.6
var attackChargeTimer:float = 0
var attackActiveWaitTime:float = 1.5
var attackActiveTimer:float = attackActiveWaitTime
var searchTimer:float = 0
var searchWaitTime:float = 0.5
var visionSensor:Area2D
@export var isDummyMode:bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	damage_taken.connect(StatTracker.character_took_damage.bind(self))
	exploded.connect(StatTracker.character_exploded.bind(self))
	add_to_group("Enemies")
	visionSensor = $VisionSensor
	visionSensor.connect("object_detected", object_detected)
	#($Smasher as SmasherVisualEffect).PopulateTipPolygons(boundingPolygon)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	if(isDummyMode):
		return
	if(IsAttackActive()):
		HandleActiveAttack(delta)
	if(target):
		if(IsChargeAttackAllowed()):
			ChargeAttack(delta)

func _physics_process(_delta:float) -> void:
	if(target == null || IsAttackActive() || isDummyMode):
		return
	var dist:float = (target.global_position - global_position).length_squared()
	if(dist > maxFollowDist):
		apply_central_force(force * (target.global_position - global_position).normalized())
	elif(dist < lerp(minFollowDistRange.x, minFollowDistRange.y, GetAttackChargePercentage())):
		apply_central_force(force * (global_position - target.global_position).normalized())

func _integrate_forces(state:PhysicsDirectBodyState2D) -> void:
	if(target == null || IsAttackActive() || isDummyMode):
		return
	var newTransform:Transform2D
	newTransform = state.transform.looking_at(target.global_position)
	newTransform = state.transform.rotated_local(lerp_angle(0, newTransform.get_rotation() - state.transform.get_rotation(), rotationSpeed*state.step))
	state.transform = newTransform

func HandleActiveAttack(delta:float) -> void:
	attackActiveTimer += delta
	if(attackActiveTimer >= attackActiveWaitTime):
		($Smasher/RaycastCollider as RaycastCollider).Disable()
		ToggleTrails(false)

func ChargeAttack(delta:float) -> void:
	attackChargeTimer += delta
	UpdateSmasherVisualEffect(GetAttackChargePercentage())
	if(attackChargeTimer >= attackChargeWaitTime):
		BeginAttack()
		attackChargeTimer = 0

func BeginAttack() -> void:
	UpdateSmasherVisualEffect(0.99)
	apply_central_impulse(transform.x.normalized() * 5000)
	($Smasher/RaycastCollider as RaycastCollider).Enable()
	ToggleTrails(true)
	attackActiveTimer = 0

func StopCharging() -> void:
	#if(IsAttackActive()):
		#return
	#attackChargeTimer = 0
	#UpdateSmasherVisualEffect(GetAttackChargePercentage())
	pass

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
	StopCharging()
	visionSensor.monitoring = true
	can_sleep = true
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




func ToggleTrails(pEnabled:bool) -> void:
	var maxLen:int = 0
	if(pEnabled):
		maxLen = 40
	($Smasher/RaycastCollider/RaycastNode/ThrustTrail as Trail).MAX_LENGTH = maxLen
	($Smasher/RaycastCollider/RaycastNode2/ThrustTrail as Trail).MAX_LENGTH = maxLen
	($Smasher/RaycastCollider/RaycastNode3/ThrustTrail as Trail).MAX_LENGTH = maxLen
	($Smasher/RaycastCollider/RaycastNode4/ThrustTrail as Trail).MAX_LENGTH = maxLen
	($Smasher/RaycastCollider/RaycastNode5/ThrustTrail as Trail).MAX_LENGTH = maxLen
	($Smasher/RaycastCollider/RaycastNode6/ThrustTrail as Trail).MAX_LENGTH = maxLen
	($Smasher/RaycastCollider/RaycastNode7/ThrustTrail as Trail).MAX_LENGTH = maxLen

func GetAttackChargePercentage() -> float:
	return min(attackChargeTimer/attackChargeWarningWaitTime, 1.0)

func IsAttackActive() -> bool:
	return attackActiveTimer < attackActiveWaitTime

func IsChargeAttackAllowed() -> bool:
	var dist:float = (target.global_position - global_position).length_squared()
	return !IsAttackActive() && (dist <= attackStartMaxDist || attackChargeTimer > 0)

func UpdateSmasherVisualEffect(pAttackChargePercentage:float) -> void:
	($Smasher as SmasherVisualEffect).UpdateAttackChargePercentage(pAttackChargePercentage)

func HandleHit(pHitData:HitData) -> void:
	super.HandleHit(pHitData)
	if(pHitData.hitOwner is Golem && !target):
		TargetFound(pHitData.hitOwner)
