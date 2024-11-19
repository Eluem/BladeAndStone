class_name HitData
extends Object
var hitOwner:Node2D
var collider:Variant
var collider_id:Variant
var normal:Vector2
var position:Vector2
var rid:RID
var shape:Variant
var hitDirection:Vector2
var lookDirection:Vector2
var damage:int
var knockback:float
var alreadyHit:bool #Indicates that this the object being hit was already hit by this attack before

func _init(pHitOwner:Node2D, pHitResult:Dictionary, pHitDirection:Vector2 = Vector2.ZERO, pLookDirection:Vector2 = Vector2.ZERO, pDamage:int = 0, pKnockback:float = 0, pPosition:Vector2 = Vector2.ZERO, pAlreadyHit:bool = false) -> void:
	hitOwner = pHitOwner
	collider = pHitResult.collider
	collider_id = pHitResult.collider_id
	normal = pHitResult.normal
	if(pHitResult.has("position")):
		position = pHitResult.position
	else:
		position = pPosition
	rid = pHitResult.rid
	shape = pHitResult.shape
	if(pHitResult.has("hitDirection")):
		hitDirection = pHitResult.hitDirection
	else:
		hitDirection = pHitDirection
	if(pHitResult.has(("lookDirection"))):
		lookDirection = pHitResult.lookDirection
	else:
		lookDirection = pLookDirection
	if(pHitResult.has("damage")):
		damage = pHitResult.damage
	else:
		damage = pDamage
	if(pHitResult.has("knockback")):
		knockback = pHitResult.knockback
	else:
		knockback = pKnockback
	alreadyHit = pAlreadyHit
