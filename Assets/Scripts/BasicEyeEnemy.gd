extends RigidBodyHittable
class_name BasicEyeEnemy

@onready var visionSensor:VisionSensor = $VisionSensor
@onready var navigationAgent2d:NavigationAgent2D = $NavigationAgent2D

@onready var chargeUpSFX:AudioStreamPlayer2D = $ChargeUpSFX
@onready var fireSFX:AudioStreamPlayer2D = $FireSFX

var target:Node2D

#New navigation features:
var targetPos:Vector2
var navPath:PackedVector2Array
var navSafeVelocity:Vector2

var force:float = 1000 #500
var maxSpeed:float = 50 #TODO: Implement max speed
var maxFollowDist:float = 500
var maxFollowDistSquared:float = maxFollowDist**2
var minFollowDist:float = 300
var minFollowDistSquared:float = minFollowDist**2
var rotationSpeed:float = 3
var eyeBoltChargeTimer:float = 0
var eyeBoltChargeWaitTime:float = 4
var eyeBoltAlmostCharged:float = 2
var eyeBoltRechargeDelayTimer:float = 1
var eyeBoltRechargeDelay:float = 1
var chargeEffect:GPUParticles2D
var standardChargeParticleProcessMaterial:ParticleProcessMaterial
var standardChargeEffectLifeTime:float
var interruptedChargeParticleProcessMaterial:ParticleProcessMaterial

var lastLineOfSightCheckTime:float
var lastHasLineOfSightVal:bool = false
var lineOfSightBrokenTime:float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	damage_taken.connect(StatTracker.character_took_damage.bind(self))
	exploded.connect(StatTracker.character_exploded.bind(self))
	add_to_group("Enemies")
	chargeEffect = $ChargeEffect
	standardChargeParticleProcessMaterial = chargeEffect.process_material
	standardChargeEffectLifeTime = chargeEffect.lifetime
	interruptedChargeParticleProcessMaterial = chargeEffect.process_material.duplicate(true)
	interruptedChargeParticleProcessMaterial.radial_velocity_min = 400
	interruptedChargeParticleProcessMaterial.orbit_velocity_max = 0
	visionSensor.object_detected.connect(object_detected)
	navigationAgent2d.velocity_computed.connect(_navigation_computed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	if(target != null):
		UpdateLineOfSightBrokenTime(delta)
		if(HasLineOfSight() || lineOfSightBrokenTime < 0.35):
			ChargeEyeBolt(delta)
		elif eyeBoltChargeTimer > 0 && lineOfSightBrokenTime >= 0.35:
			StopCharging()
			eyeBoltRechargeDelay = 0.5
		#UpdateNavInfo_Old()


func _physics_process(_delta:float) -> void:
	if(target == null):
		return
	var dist:float = (target.global_position - global_position).length_squared()
	#if(dist > maxFollowDistSquared || !HasLineOfSight()):
	UpdateNavInfo(dist)
		#apply_central_force(force * (target.global_position - global_position).normalized())
		#apply_central_force(force * (targetPos - global_position).normalized())
	apply_central_force(force * navSafeVelocity.normalized())
	if(dist < minFollowDistSquared && HasLineOfSight()):
		apply_central_force(force * (global_position - target.global_position).normalized())


func _integrate_forces(state:PhysicsDirectBodyState2D) -> void:
	if(target == null):
		return
	#var newTransform:Transform2D = state.transform
	#state.transform = newTransform.looking_at(target.global_position)
	var newTransform:Transform2D
	if(HasLineOfSight()):
		newTransform = state.transform.looking_at(target.global_position)
	else:
		newTransform = state.transform.looking_at(targetPos)
	newTransform = state.transform.rotated_local(lerp_angle(0, newTransform.get_rotation() - state.transform.get_rotation(), rotationSpeed*state.step))
	state.transform = newTransform


func ChargeEyeBolt(delta:float) -> void:
	if(eyeBoltRechargeDelayTimer < eyeBoltRechargeDelay):
		eyeBoltRechargeDelayTimer += delta
		return
	if(chargeEffect.process_material != standardChargeParticleProcessMaterial):
		chargeEffect.process_material = standardChargeParticleProcessMaterial
		chargeEffect.lifetime = standardChargeEffectLifeTime
		chargeEffect.restart()
		chargeEffect.emitting = false
	eyeBoltChargeTimer += delta
	if(!chargeEffect.emitting):
		chargeEffect.emitting = true
		chargeUpSFX.play()
	if(eyeBoltChargeTimer > eyeBoltAlmostCharged):
		chargeEffect.amount_ratio = 0
	else:
		chargeEffect.amount_ratio = clampf(eyeBoltChargeTimer/eyeBoltAlmostCharged, 0, 1)
	if(eyeBoltChargeTimer >= eyeBoltChargeWaitTime):
		FireEyeBolt()
		StopCharging()
		eyeBoltRechargeDelayTimer = 0


func FireEyeBolt() -> void:
	var eyeBolt:EyeBolt = EyeBolt.Spawn(get_tree().current_scene, self, position, transform.x)
	eyeBolt.AddCollisionException(get_rid())
	#Recoil
	apply_central_impulse(transform.x.normalized() * -500)
	fireSFX.play()


func object_detected(pBody:Node2D) -> void:
	TargetFound(pBody)


func HandleHit(pHitData:HitData) -> void:
	super.HandleHit(pHitData)
	StopCharging()
	eyeBoltRechargeDelayTimer = 0
	chargeEffect.process_material = interruptedChargeParticleProcessMaterial
	chargeEffect.lifetime = 4
	if(pHitData.hitOwner is Golem && !target):
		TargetFound(pHitData.hitOwner)


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
	eyeBoltRechargeDelayTimer = eyeBoltRechargeDelay
	visionSensor.monitoring = true
	can_sleep = true
	target = null
	
	var viewPort:Viewport = get_viewport()
	if(viewPort):
		var cameraCast:CameraMultitracking = get_viewport().get_camera_2d()
		cameraCast.RemoveTrackTarget(self)


func StopCharging() -> void:
	chargeUpSFX.stop()
	eyeBoltChargeTimer = 0
	chargeEffect.emitting = false


func Die(pHitOwner:Node2D, pDir:Vector2, pForce:float) -> void:
	chargeEffect.one_shot = true
	#chargeEffect.reparent(get_tree().root.get_child(0))
	chargeEffect.reparent(get_tree().current_scene)
	chargeEffect.set_script(load("res://Assets/Scripts/DeleteFinishedParticles.gd"))
	super.Die(pHitOwner, pDir, pForce)


func UpdateNavInfo(pDist:float) -> void:
	if(HasClearLineOfSight()):
		navigationAgent2d.target_desired_distance = maxFollowDist
		if(pDist <= maxFollowDistSquared):
			navigationAgent2d.neighbor_distance = 1000
		else:
			navigationAgent2d.neighbor_distance = 500
	else:
		navigationAgent2d.target_desired_distance = 1
		if(pDist <= maxFollowDistSquared * 2):
			navigationAgent2d.neighbor_distance = 1
		else:
			navigationAgent2d.neighbor_distance = 500
	
	navigationAgent2d.target_position = target.global_position
	navigationAgent2d.velocity = (targetPos - global_position)
	targetPos = navigationAgent2d.get_next_path_position()


func UpdateNavInfo_Old() -> void:
	if(HasLineOfSight()):
		targetPos = target.global_position
	else:
		#navigationAgent2d.target_position = target.global_position
		#targetPos = navigationAgent2d.get_next_path_position()
		navPath = NavigationServer2D.map_get_path(NavigationServer2D.get_maps()[0], global_position, target.global_position, true)
		targetPos = navPath[1]


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


#Expanded line of sight check to help make sure NPC gets into the room far enough to
#properly get a shot off
func HasClearLineOfSight() -> bool:
	if(target == null):
		navigationAgent2d.path_postprocessing = NavigationPathQueryParameters2D.PATH_POSTPROCESSING_CORRIDORFUNNEL
		return false
	if(HasLineOfSight()):
		var clearSight:bool
		var perpendicular:Vector2 = transform.basis_xform(Vector2.UP) * 40
		clearSight = RaycastHelper.CheckLineOfSight(get_world_2d().direct_space_state, global_position + perpendicular, target)
		if(clearSight):
			clearSight = RaycastHelper.CheckLineOfSight(get_world_2d().direct_space_state, global_position - perpendicular, target)
			if(clearSight):
				navigationAgent2d.path_postprocessing = NavigationPathQueryParameters2D.PATH_POSTPROCESSING_CORRIDORFUNNEL
				return true
		navigationAgent2d.path_postprocessing = NavigationPathQueryParameters2D.PATH_POSTPROCESSING_EDGECENTERED
	navigationAgent2d.path_postprocessing = NavigationPathQueryParameters2D.PATH_POSTPROCESSING_CORRIDORFUNNEL
	return false


func UpdateLineOfSightBrokenTime(pDelta:float) -> void:
	if(HasLineOfSight()):
		lineOfSightBrokenTime = 0
	else:
		lineOfSightBrokenTime += pDelta
