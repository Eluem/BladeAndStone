extends RigidBodyHittable

var target:Node2D
var hasTarget:bool
var force:float = 500
var maxSpeed:float = 50 #TODO: Implement max speed
var maxFollowDist:float = 500**2
var minFollowDist:float = 300**2
var rotationSpeed:float = 3
var eyeBoltChargeTimer:float = 0
var eyeBoltChargeWaitTime:float = 4
var eyeBoltAlmostCharged:float = 2
var eyeBoltRechargeDelayTimer:float = 1
var eyeBoltRechargeDelay:float = 1
var searchTimer:float = 0
var searchWaitTime:float = 0.5
var visionSensor:Area2D
var chargeEffect:GPUParticles2D
var standardChargeParticleProcessMaterial:ParticleProcessMaterial
var standardChargeEffectLifeTime:float
var interruptedChargeParticleProcessMaterial:ParticleProcessMaterial

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	chargeEffect = $ChargeEffect
	standardChargeParticleProcessMaterial = chargeEffect.process_material
	standardChargeEffectLifeTime = chargeEffect.lifetime
	interruptedChargeParticleProcessMaterial = chargeEffect.process_material.duplicate(true)
	interruptedChargeParticleProcessMaterial.radial_velocity_min = 400
	interruptedChargeParticleProcessMaterial.orbit_velocity_max = 0
	visionSensor = $VisionSensor
	visionSensor.connect("object_detected", object_detected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(target != null):
		if(!hasTarget):
			TargetFound()
		ChargeEyeBolt(delta)
	elif(hasTarget):
		TargetLost()


func _physics_process(_delta: float) -> void:
	if(target == null):
		return
	var dist:float = (target.global_position - global_position).length_squared()
	if(dist > maxFollowDist):
		apply_central_force(force * (target.global_position - global_position).normalized())
	elif(dist < minFollowDist):
		apply_central_force(force * (global_position - target.global_position).normalized())

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if(target == null):
		return
	#var newTransform:Transform2D = state.transform
	#state.transform = newTransform.looking_at(target.global_position)
	var newTransform:Transform2D
	newTransform = state.transform.looking_at(target.global_position)
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
	eyeBoltChargeTimer += delta
	chargeEffect.emitting = true
	if(eyeBoltChargeTimer > eyeBoltAlmostCharged):
		chargeEffect.amount_ratio = 0
	else:
		chargeEffect.amount_ratio = clampf(eyeBoltChargeTimer/eyeBoltAlmostCharged, 0, 1)
	if(eyeBoltChargeTimer >= eyeBoltChargeWaitTime):
		FireEyeBolt()
		StopCharging()
		eyeBoltRechargeDelayTimer = 0

func FireEyeBolt() -> void:
	var eyeBolt:EyeBolt = EyeBolt.Spawn(get_node("/root"), position, transform.x)
	eyeBolt.AddCollisionException(get_rid())
	#Recoil
	apply_central_impulse(transform.x.normalized() * -500)

func object_detected(pBody:Node2D) -> void:
	target = pBody

func HandleHit(pHitData:HitData) -> void:
	super.HandleHit(pHitData)
	StopCharging()
	eyeBoltRechargeDelayTimer = 0
	chargeEffect.process_material = interruptedChargeParticleProcessMaterial
	chargeEffect.lifetime = 4

func TargetFound() -> void:
	can_sleep = false
	visionSensor.monitoring = false
	hasTarget = true

func TargetLost() -> void:
	StopCharging()
	visionSensor.monitoring = true
	can_sleep = true
	hasTarget = false

func StopCharging() -> void:
	eyeBoltChargeTimer = 0
	chargeEffect.emitting = false

func Die(pDir:Vector2, pForce:float) -> void:
	chargeEffect.one_shot = true
	chargeEffect.reparent(get_tree().root.get_child(0))
	chargeEffect.set_script(load("res://Assets/Scripts/DeleteFinishedParticles.gd"))
	super.Die(pDir, pForce)
	
