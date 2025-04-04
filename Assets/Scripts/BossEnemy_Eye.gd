extends Node2D
class_name BossEnemy_Eye

enum ProjectileType
{
	 Small
	,Large
}

@onready var chargeUpSFXPlayer:AudioStreamPlayer2D = $ChargeUpSFXPlayer
@onready var fireSFXPlayer:AudioStreamPlayer2D = $FireSFXPlayer
@onready var chargeEffect:GPUParticles2D = $ChargeEffect

@export var projectileType:ProjectileType
@export var burstRoundDelay:float = 0.3


var target:Node2D
var boss:RigidBody2D
var bossRID:RID

var charging:bool = false
var bursting:bool = false
var roundsInBurst:int = 1
@export var eyeBoltChargeWaitTime:float = 4
var eyeBoltChargeTimer:float = 0
var defaultEyeBoltChargeWaitTime:float = 4
var eyeBoltAlmostCharged:float
var burstRoundDelayTimer:float = 0
#var eyeBoltRechargeDelayTimer:float = 1
#var eyeBoltRechargeDelay:float = 1
var standardChargeParticleProcessMaterial:ParticleProcessMaterial
var standardChargeEffectLifeTime:float
var initialProjectilePath:Array[Node]
var initialProjectilePath2:Array[Node]
var hasSecondFirePath:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boss = owner
	bossRID = boss.get_rid()
	eyeBoltAlmostCharged = eyeBoltChargeWaitTime/2
	standardChargeParticleProcessMaterial = chargeEffect.process_material
	standardChargeEffectLifeTime = chargeEffect.lifetime
	var initialProjectilePathNode:Node = get_node_or_null("InitialProjectilePath")
	if(initialProjectilePathNode != null):
		initialProjectilePath = initialProjectilePathNode.get_children()
	var initialProjectilePathNode2:Node = get_node_or_null("InitialProjectilePath2")
	if(initialProjectilePathNode2 != null):
		hasSecondFirePath = true
		initialProjectilePath2 = initialProjectilePathNode2.get_children()
	chargeUpSFXPlayer.pitch_scale = defaultEyeBoltChargeWaitTime / eyeBoltChargeWaitTime


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	if(charging):
		ChargeEyeBolt(delta)
	elif(bursting):
		HandleBurst(delta)


func ChargeEyeBolt(pDelta:float) -> void:
	if(chargeEffect.process_material != standardChargeParticleProcessMaterial):
		chargeEffect.process_material = standardChargeParticleProcessMaterial
		chargeEffect.lifetime = standardChargeEffectLifeTime
		chargeEffect.restart()
		chargeEffect.emitting = false
	eyeBoltChargeTimer += pDelta
	if(!chargeEffect.emitting):
		chargeEffect.emitting = true
		chargeUpSFXPlayer.play()
	if(eyeBoltChargeTimer > eyeBoltAlmostCharged):
		chargeEffect.amount_ratio = 0
	else:
		chargeEffect.amount_ratio = clampf(eyeBoltChargeTimer/eyeBoltAlmostCharged, 0, 1)
	if(eyeBoltChargeTimer >= eyeBoltChargeWaitTime):
		Fire()
		StopCharging()
		UpdateBurst()


func UpdateBurst() -> void:
	roundsInBurst -= 1
	if(roundsInBurst <= 0):
		bursting = false


func HandleBurst(pDelta:float) -> void:
	burstRoundDelayTimer += pDelta
	if(burstRoundDelayTimer >= burstRoundDelay):
		burstRoundDelayTimer = 0
		Fire()
		UpdateBurst()


func Fire() -> void:
	_Fire(initialProjectilePath)
	if(hasSecondFirePath):
		_Fire(initialProjectilePath2)


func _Fire(pPath:Array[Node]) -> void:
	var trackingProjectile:TrackingProjectile
	match projectileType:
		ProjectileType.Small:
			trackingProjectile = Boss_EyeBolt_Small.Spawn(get_tree().current_scene, boss, global_position, global_transform.x, target)
		ProjectileType.Large:
			trackingProjectile = Boss_EyeBolt_Large.Spawn(get_tree().current_scene, boss, global_position, global_transform.x, target)
	trackingProjectile.PopulateInitialPathWithNodes(pPath)
	trackingProjectile.AddCollisionException(bossRID)
	fireSFXPlayer.play()


func StopCharging() -> void:
	charging = false
	chargeUpSFXPlayer.stop()
	eyeBoltChargeTimer = 0
	chargeEffect.emitting = false


func StartCharging(pRoundsInBurst:int = 1) -> void:
	charging = true
	roundsInBurst = pRoundsInBurst
	if(pRoundsInBurst > 1):
		bursting = true


func Die() -> void:
	if(chargeEffect.emitting):
		SplitOutChargeParticleEffect()


func SplitOutChargeParticleEffect() -> void:
	var chargeEffectPointer:GPUParticles2D = chargeEffect
	chargeEffect = chargeEffect.duplicate(true)
	add_child(chargeEffect)
	chargeEffectPointer.one_shot = true
	chargeEffectPointer.emitting = true
	chargeEffectPointer.amount_ratio = 0
	chargeEffectPointer.reparent(get_tree().current_scene)


func SetTarget(pTarget:Node2D) -> void:
	if(target != null):
		if(target.tree_exited.is_connected(SetTarget)):
			target.tree_exited.disconnect(SetTarget)
	target = pTarget
	if(target != null):
		target.tree_exited.connect(SetTarget.bind(null))


func IsBusy() -> bool:
	return charging || bursting
