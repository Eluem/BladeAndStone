extends RigidBody2D
class_name RigidBodyHittable
@export var health:int = 100
var debugInfo:DebugInfo

signal health_changed(pHealth:int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	debugInfo = get_tree().get_root().get_node("World2D") as DebugInfo

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func HandleHit(pHitData:HitData) -> void:
	ApplyKnockback(pHitData.lookDirection as Vector2, pHitData.knockback as float)
	ApplyDamage(pHitData.damage as int)
	HitEffect(pHitData.position as Vector2, (pHitData.hitDirection as Vector2).normalized() * (pHitData.knockback as float))

func ApplyDamage(pDamage:int) -> void:
	health -= pDamage
	health_changed.emit(health)
	if(health <= 0):
		Die()

func ApplyHeal(pHeal:int) -> void:
	health += pHeal
	health_changed.emit(health)

func ApplyKnockback(pDirection:Vector2, pKnockback:float) -> void:
	apply_central_impulse(pDirection.normalized() * pKnockback)

func HitEffect(pPosition:Vector2, pForce:Vector2) -> void:
	if(debugInfo.debugUIEnabled):
		DebugLine.DrawLine(get_node("/root"), pPosition, pPosition + pForce, Color.WEB_PURPLE, 5, 10)
	if(debugInfo.effectsEnabled):
		LivingRockHit.Spawn(get_node("/root"), pPosition, pForce)
		
func Die() -> void:
	queue_free()
