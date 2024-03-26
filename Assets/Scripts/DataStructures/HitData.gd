class_name HitData
extends Object
var collider:Variant
var collider_id:Variant
var normal:Vector2
var position:Vector2
var rid:RID
var shape:Variant
var swingDirection:Vector2
var lookDirection:Vector2
var damage:int
var knockback:float
	
func _init(pHitData:Dictionary, pSwingDirection:Vector2 = Vector2.ZERO, pLookDirection:Vector2 = Vector2.ZERO, pDamage:int = 0, pKnockback:float = 0) -> void:
	collider = pHitData.collider
	collider_id = pHitData.collider_id
	normal = pHitData.normal
	position = pHitData.position
	rid = pHitData.rid
	shape = pHitData.shape
	if(pHitData.has("swingDirection")):
		swingDirection = pHitData.swingDirection
	else:
		swingDirection = pSwingDirection
	if(pHitData.has(("lookDirection"))):
		lookDirection = pHitData.lookDirection
	else:
		lookDirection = pLookDirection
	if(pHitData.has("damage")):
		damage = pHitData.damage
	else:
		damage = pDamage
	if(pHitData.has("knockback")):
		knockback = pHitData.knockback
	else:
		knockback = pKnockback
