extends RigidBodyHittable
class_name DashSmashEnemy

@onready var visionSensor:VisionSensor = $VisionSensor
@onready var navigationAgent2d:NavigationAgent2D = $NavigationAgent2D

@onready var attackWindUpSFXPlayer:AudioStreamPlayer2D = $AttackWindUpSFXPlayer
@onready var attackReleaseSFXPlayer:AudioStreamPlayer2D = $AttackReleaseSFXPlayer

@export var isDummyMode:bool = false

var target:Node2D
var force:float = 3000 #500
var maxSpeed:float = 500**2
var maxFollowDist:float = 500**2
var minFollowDistRange:Vector2 = Vector2(400**2, maxFollowDist * 1.5)
var attackStartMaxDist:float = 450**2
var rotationSpeed:float = 3
var attackChargeWaitTime:float = 4
var attackChargeWarningWaitTime:float = 3.6
var attackChargeTimer:float = 0
var attackActiveWaitTime:float = 1.5
var attackActiveTimer:float = attackActiveWaitTime

#New navigation features:
var targetPos:Vector2
var navSafeVelocity:Vector2
var lastLineOfSightCheckTime:float
var lastHasLineOfSightVal:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	damage_taken.connect(StatTracker.character_took_damage.bind(self))
	exploded.connect(StatTracker.character_exploded.bind(self))
	add_to_group("Enemies")
	visionSensor.object_detected.connect(object_detected)
	($Smasher as SmasherVisualEffect).PopulateTipPolygons(boundingPolygon)
	navigationAgent2d.velocity_computed.connect(_navigation_computed)


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
	
	if(HasLineOfSight()):
		var dir:Vector2 = (target.global_position - global_position).normalized()
		if(dist > maxFollowDist):# && (!IsAttackCharging() || dist > maxFollowDist * 2.5)):
			var currSpeed:float = linear_velocity.dot(transform.x)**2
			if(currSpeed <= maxSpeed):
				if(IsAttackCharging() && dist <= maxFollowDist * 2.5):
					apply_central_force(-mass * 2 * linear_velocity)
				else:
					apply_central_force(force * dir)
		else:
			var attackChargePercentage:float = GetAttackChargePercentage()
			if(dist < lerp(minFollowDistRange.x, minFollowDistRange.y, attackChargePercentage)):
				apply_central_force(force * -dir)
		
		#Additional stopping force if too close to target
		if(dist < minFollowDistRange.x):
			apply_central_force(-mass * linear_velocity)
		#Reduce sideways velocity if attack is charging
		if(IsAttackCharging()):
			#var counterForce:Vector2 = -mass * (linear_velocity - (transform.x * linear_velocity.length()))
			#var counterForce:Vector2 = -mass * (linear_velocity - (transform.x * transform.x.dot(linear_velocity)))
			var counterForce:Vector2 = -mass * (linear_velocity - (transform.x * linear_velocity.dot(transform.x)))
			#var counterForce:Vector2 = -mass * linear_velocity
			apply_central_force(counterForce)
		#Apply some counter side force even if not charging
		else:
			var counterForce:Vector2 = -1 * (linear_velocity - (transform.x * linear_velocity.dot(transform.x)))
			apply_central_force(counterForce)
	else:
		UpdateNavInfo(dist)
		if(linear_velocity.length_squared() <= maxSpeed):
			apply_central_force(force * navSafeVelocity.normalized())


func _integrate_forces(state:PhysicsDirectBodyState2D) -> void:
	if(target == null || IsAttackActive() || isDummyMode):
		return
	var newTransform:Transform2D
	if(HasLineOfSight()):
		newTransform = state.transform.looking_at(target.global_position)
	else:
		newTransform = state.transform.looking_at(targetPos)
	newTransform = state.transform.rotated_local(lerp_angle(0, newTransform.get_rotation() - state.transform.get_rotation(), rotationSpeed*state.step))
	state.transform = newTransform


func HandleActiveAttack(delta:float) -> void:
	attackActiveTimer += delta
	if(attackActiveTimer >= attackActiveWaitTime):
		($Smasher/RaycastCollider as RaycastCollider).Disable()
		ToggleTrails(false)
		UpdateSmasherVisualEffect(GetAttackChargePercentage())


func ChargeAttack(delta:float) -> void:
	if(attackChargeTimer >= attackChargeWaitTime - 1.2 && attackChargeTimer < attackChargeWaitTime - 1 && !attackWindUpSFXPlayer.playing):
		attackWindUpSFXPlayer.play()
	attackChargeTimer += delta
	UpdateSmasherVisualEffect(GetAttackChargePercentage())
	if(attackChargeTimer >= attackChargeWaitTime):
		BeginAttack()
		attackChargeTimer = 0


func BeginAttack() -> void:
	attackReleaseSFXPlayer.play()
	UpdateSmasherVisualEffect(0.99)
	linear_velocity = Vector2.ZERO
	apply_central_impulse(transform.x.normalized() * 5000)
	($Smasher/RaycastCollider as RaycastCollider).Enable()
	ToggleTrails(true)
	attackActiveTimer = 0


func StopCharging() -> void:
	if(IsAttackActive()):
		return
	attackChargeTimer = 0
	UpdateSmasherVisualEffect(GetAttackChargePercentage())


func object_detected(pBody:Node2D) -> void:
	TargetFound(pBody)


func TargetFound(pTarget:Node2D) -> void:
	target = pTarget
	target.tree_exited.connect(TargetLost)
	can_sleep = false
	visionSensor.monitoring = false
	
	var cameraCast:CameraMultitracking = get_viewport().get_camera_2d()
	cameraCast.AddTrackTarget(self, 1)


func TargetLost() -> void:
	if(target == null):
		return
	StopCharging()
	visionSensor.monitoring = true
	can_sleep = true
	target = null
	
	var viewPort:Viewport = get_viewport()
	if(viewPort):
		var cameraCast:CameraMultitracking = get_viewport().get_camera_2d()
		cameraCast.RemoveTrackTarget(self)


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
	return !IsAttackActive() && ((dist <= attackStartMaxDist && HasLineOfSight()) || IsAttackCharging())


func IsAttackCharging() -> bool:
	return attackChargeTimer > 0


func UpdateSmasherVisualEffect(pAttackChargePercentage:float) -> void:
	($Smasher as SmasherVisualEffect).UpdateAttackChargePercentage(pAttackChargePercentage)


func HandleHit(pHitData:HitData) -> void:
	super.HandleHit(pHitData)
	if(pHitData.hitOwner is Golem && !target):
		TargetFound(pHitData.hitOwner)


func UpdateNavInfo(_pDist:float) -> void:
	navigationAgent2d.target_position = target.global_position
	navigationAgent2d.velocity = (targetPos - global_position)
	targetPos = navigationAgent2d.get_next_path_position()


func _navigation_computed(pSafeVelocity:Vector2) -> void:
	navSafeVelocity = pSafeVelocity


func HasLineOfSight() -> bool:
	if(target == null):
		return false
	var checkTime:float = Time.get_ticks_msec()
	if(checkTime - lastLineOfSightCheckTime > 100):
		lastHasLineOfSightVal = RaycastHelper.CheckLineOfSight(get_world_2d().direct_space_state, global_position, target)
		lastLineOfSightCheckTime = checkTime
	return lastHasLineOfSightVal
