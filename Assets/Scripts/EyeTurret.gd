extends StaticBodyHittable
class_name EyeTurret

@onready var eye:Node2D = $EyeTurretEye
@onready var projectileSpawnPoint:Node2D = $EyeTurretEye/ProjectileSpawnPoint
@onready var shieldSprite:Sprite2D = $Shield

@onready var visionSensor:Area2D = $VisionSensor
@onready var chargeEffect:GPUParticles2D = $EyeTurretEye/ChargeEffect
@onready var hurtSFX:AudioStreamPlayer2D = $HurtSFX
@onready var chargeUpSFX:AudioStreamPlayer2D = $ChargeUpSFX
@onready var fireSFX:AudioStreamPlayer2D = $FireSFX

@export var isEyeOpen:bool = true:
	set(pValue):
		isEyeOpen = pValue
		if(visionSensor):
			visionSensor.monitoring = isEyeOpen
@export var damage:int = 30

var target:Node2D
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
var standardChargeParticleProcessMaterial:ParticleProcessMaterial
var standardChargeEffectLifeTime:float
var maxRotationRange:Vector2 = Vector2(deg_to_rad(-70), deg_to_rad(70))
var targetLossTimer:float = 0
var targetLossDelay:float = 2.0
var lastHitSFXTime:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	add_to_group("Enemies")
	if(!isEyeOpen):
		visionSensor.monitoring = false
	standardChargeParticleProcessMaterial = chargeEffect.process_material
	standardChargeEffectLifeTime = chargeEffect.lifetime
	
	visionSensor.connect("object_detected", object_detected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	if(target != null):
		ValidateTarget(delta)
		if(isEyeOpen && target != null):
			ChargeEyeBolt(delta)
	HandleShieldEffect(delta)


func _physics_process(delta:float) -> void:
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
		FireProjectile()
		StopCharging()
		eyeBoltRechargeDelayTimer = 0

func FireProjectile() -> void:
	var projectile:EyeTurretBolt = EyeTurretBolt.Spawn(get_tree().current_scene, self, projectileSpawnPoint.global_position, projectileSpawnPoint.global_transform.x)
	projectile.z_index = -2
	projectile.damage = damage
	projectile.AddCollisionException(get_rid())
	fireSFX.play()


func object_detected(pBody:Node2D) -> void:
	TargetFound(pBody)


func TargetFound(pTarget:Node2D) -> void:
	target = pTarget
	target.tree_exited.connect(TargetLost)
	visionSensor.monitoring = false
	
	var cameraCast:CameraMultitracking = get_viewport().get_camera_2d()
	cameraCast.AddTrackTarget(self, 1)


func TargetLost() -> void:
	if(target == null):
		return
	StopCharging()
	eyeBoltRechargeDelayTimer = eyeBoltRechargeDelay
	visionSensor.monitoring = true
	target.tree_exited.disconnect(TargetLost)
	target = null

	var viewPort:Viewport = get_viewport()
	if(viewPort):
		var cameraCast:CameraMultitracking = get_viewport().get_camera_2d()
		cameraCast.RemoveTrackTarget(self)


func ValidateTarget(pDelta:float) -> void:
	var spaceState:PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	if(!RaycastHelper.CheckLineOfSight(spaceState, global_position, target)):
		if(targetLossTimer < targetLossDelay):
			targetLossTimer += pDelta
		else:
			TargetLost()
	else:
		targetLossTimer = 0


func StopCharging() -> void:
	chargeUpSFX.stop()
	eyeBoltChargeTimer = 0
	chargeEffect.emitting = false


func HandleShieldEffect(pDelta:float) -> void:
	if(shieldSprite.modulate.a > 0):
		shieldSprite.modulate.a -= pDelta


func HitEffect(pPosition:Vector2, pForce:Vector2) -> void:
	super.HitEffect(pPosition, pForce)
	shieldSprite.modulate.a = 0.9
	
	var currHitSFXTime:float = Time.get_ticks_msec()
	if(currHitSFXTime-lastHitSFXTime > 20):
		var hurtSFXClone:AudioStreamPlayer2D = hurtSFX.duplicate()
		add_child(hurtSFXClone)
		hurtSFXClone.finished.connect(hurtSFXClone.queue_free)
		hurtSFXClone.play()
		lastHitSFXTime = currHitSFXTime
	#if(!hurtSFX.playing || hurtSFX.get_playback_position() + AudioServer.get_time_since_last_mix() > 0.8):
	#	hurtSFX.play()
