extends StaticBodyHittable

@export var isEyeOpen:bool = true
@export var damage:int = 30

@onready var eye: Node2D = $EyeTurretEye
@onready var projectileSpawnPoint:Node2D = $EyeTurretEye/ProjectileSpawnPoint
@onready var shieldSprite:Sprite2D = $Shield

@onready var visionSensor:Area2D = $VisionSensor
@onready var chargeEffect:GPUParticles2D = $EyeTurretEye/ChargeEffect

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
var standardChargeParticleProcessMaterial:ParticleProcessMaterial
var standardChargeEffectLifeTime:float
var maxRotationRange:Vector2 = Vector2(deg_to_rad(-70), deg_to_rad(70))
var targetLossTimer:float = 0
var targetLossDelay:float = 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()

	standardChargeParticleProcessMaterial = chargeEffect.process_material
	standardChargeEffectLifeTime = chargeEffect.lifetime
	
	visionSensor.connect("object_detected", object_detected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(target != null):
		ValidateTarget(delta)
		if(!hasTarget):
			TargetFound()
		if(isEyeOpen):
			ChargeEyeBolt(delta)
	elif(hasTarget):
		TargetLost()
	HandleShieldEffect(delta)

func _physics_process(delta: float) -> void:
	if(!isEyeOpen):
		return
	if(target == null):
		eye.rotation = lerp_angle(eye.rotation, 0, rotationSpeed*delta)
		eye.rotation = clampf(eye.rotation, maxRotationRange.x, maxRotationRange.y)
	else:
		eye.global_rotation = lerp_angle(eye.global_rotation, eye.global_transform.looking_at(target.global_position).get_rotation(), rotationSpeed*delta)
		eye.rotation = clampf(eye.rotation, maxRotationRange.x, maxRotationRange.y)

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
		FireProjectile()
		StopCharging()
		eyeBoltRechargeDelayTimer = 0

func FireProjectile() -> void:
	var projectile:EyeTurretBolt = EyeTurretBolt.Spawn(get_node("/root"), projectileSpawnPoint.global_position, projectileSpawnPoint.global_transform.x)
	projectile.z_index = -2
	projectile.damage = damage
	projectile.AddCollisionException(get_rid())

func object_detected(pBody:Node2D) -> void:
	target = pBody

func TargetFound() -> void:
	visionSensor.monitoring = false
	hasTarget = true

func TargetLost() -> void:
	StopCharging()
	visionSensor.monitoring = true
	hasTarget = false

func ValidateTarget(pDelta:float) -> void:
	var spaceState:PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	if(!RaycastHelper.CheckLineOfSight(spaceState, global_position, target)):
		if(targetLossTimer < targetLossDelay):
			targetLossTimer += pDelta
		else:
			target = null
	else:
		targetLossTimer = 0

func StopCharging() -> void:
	eyeBoltChargeTimer = 0
	chargeEffect.emitting = false

func HandleShieldEffect(pDelta:float) -> void:
	if(shieldSprite.modulate.a > 0):
		shieldSprite.modulate.a -= pDelta

func HitEffect(pPosition:Vector2, pForce:Vector2) -> void:
	super.HitEffect(pPosition, pForce)
	shieldSprite.modulate.a = 0.9
