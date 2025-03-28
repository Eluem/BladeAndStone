extends Node2D
class_name BossEnemy_Eye

enum ProjectileType
{
	 Small
	,Large
}

@export var enabled:bool = true
@export var projectileType:ProjectileType
@onready var chargeUpSFXPlayer:AudioStreamPlayer2D = $ChargeUpSFXPlayer
@onready var fireSFXPlayer:AudioStreamPlayer2D = $FireSFXPlayer
@onready var chargeEffect:GPUParticles2D = $ChargeEffect

var target:Node2D
var boss:RigidBody2D
var bossRID:RID

var eyeBoltChargeTimer:float = 0
var eyeBoltChargeWaitTime:float = 4
var eyeBoltAlmostCharged:float = 2
var eyeBoltRechargeDelayTimer:float = 1
var eyeBoltRechargeDelay:float = 1
var standardChargeParticleProcessMaterial:ParticleProcessMaterial
var standardChargeEffectLifeTime:float
var interruptedChargeParticleProcessMaterial:ParticleProcessMaterial
var initialProjectilePath:Array[Node]
var initialProjectilePath2:Array[Node]
var hasSecondFirePath:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boss = owner
	bossRID = boss.get_rid()
	standardChargeParticleProcessMaterial = chargeEffect.process_material
	standardChargeEffectLifeTime = chargeEffect.lifetime
	interruptedChargeParticleProcessMaterial = chargeEffect.process_material.duplicate(true)
	interruptedChargeParticleProcessMaterial.radial_velocity_min = 400
	interruptedChargeParticleProcessMaterial.orbit_velocity_max = 0
	var initialProjectilePathNode:Node = get_node_or_null("InitialProjectilePath")
	if(initialProjectilePathNode != null):
		initialProjectilePath = initialProjectilePathNode.get_children()
	var initialProjectilePathNode2:Node = get_node_or_null("InitialProjectilePath2")
	if(initialProjectilePathNode2 != null):
		hasSecondFirePath = true
		initialProjectilePath2 = initialProjectilePathNode2.get_children()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	if(!enabled):
		return
	if(target != null):
		ChargeEyeBolt(delta)


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
		chargeUpSFXPlayer.play()
	if(eyeBoltChargeTimer > eyeBoltAlmostCharged):
		chargeEffect.amount_ratio = 0
	else:
		chargeEffect.amount_ratio = clampf(eyeBoltChargeTimer/eyeBoltAlmostCharged, 0, 1)
	if(eyeBoltChargeTimer >= eyeBoltChargeWaitTime):
		Fire(initialProjectilePath)
		if(hasSecondFirePath):
			Fire(initialProjectilePath2)
		StopCharging()
		eyeBoltRechargeDelayTimer = 0


func Fire(pPath:Array[Node]) -> void:
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
	chargeUpSFXPlayer.stop()
	eyeBoltChargeTimer = 0
	chargeEffect.emitting = false


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
