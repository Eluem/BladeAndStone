extends RigidBodyHittable

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
	visionSensor = $VisionSensor
	visionSensor.connect("object_detected", object_detected)
	($Smasher as SmasherVisualEffect).PopulateTipPolygons(boundingPolygon)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(isDummyMode):
		return
	if(IsAttackActive()):
		HandleActiveAttack(delta)
	if(target == null):
		visionSensor.monitoring = true
		can_sleep = true
	else:
		can_sleep = false
		visionSensor.monitoring = false
		if(IsChargeAttackAllowed()):
			ChargeAttack(delta)

func _physics_process(_delta: float) -> void:
	if(target == null || IsAttackActive() || isDummyMode):
		return
	var dist:float = (target.global_position - global_position).length_squared()
	if(dist > maxFollowDist):
		apply_central_force(force * (target.global_position - global_position).normalized())
	elif(dist < lerp(minFollowDistRange.x, minFollowDistRange.y, GetAttackChargePercentage())):
		apply_central_force(force * (global_position - target.global_position).normalized())

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
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
	

func object_detected(pBody:Node2D) -> void:
	target = pBody

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
