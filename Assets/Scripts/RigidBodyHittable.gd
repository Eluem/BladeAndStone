extends RigidBody2D
class_name RigidBodyHittable
@export var health:int = 100
var debugInfo:DebugInfo
var spritePolygon:Polygon2D
var boundingPolygon:Polygon2D
var mainSprite:Sprite2D

signal health_changed(pHealth:int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	debugInfo = get_tree().get_root().get_node("World2D") as DebugInfo
	mainSprite = GetMainSprite()
	spritePolygon = Geometry2DHelper.CreatePolygonFromSprite(mainSprite)[0]
	GenerateBoundingPolygon()
	GenerateOutline()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func HandleHit(pHitData:HitData) -> void:
	ApplyKnockback(pHitData.lookDirection as Vector2, pHitData.knockback as float)
	ApplyDamage(pHitData.damage as int)
	HitEffect(pHitData.position as Vector2, (pHitData.hitDirection as Vector2).normalized() * (pHitData.knockback as float))
	if(health <= 0):
		Die((pHitData.hitDirection as Vector2).normalized(), (pHitData.knockback as float))

func ApplyDamage(pDamage:int) -> void:
	health -= pDamage
	health_changed.emit(health)

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
		
func Die(pDir:Vector2, pForce:float) -> void:
	Geometry2DHelper.ExplodeSprite(mainSprite, pDir, Vector2(pForce*0.5, pForce), Vector2(-pForce/40, pForce/40), spritePolygon, 0, 1)
	queue_free()

func GetMainSprite() -> Sprite2D:
	return $MainSprite

func GenerateBoundingPolygon() -> void:
	boundingPolygon = Polygon2D.new()
	var xForm:Transform2D = Transform2D(mainSprite.rotation, Vector2.ONE, mainSprite.skew, mainSprite.position)
	boundingPolygon.polygon = xForm * spritePolygon.polygon
	#boundingPolygon.polygon = mainSprite.transform.scaled(Vector2(1/mainSprite.scale.y, 1/mainSprite.scale.x)) * spritePolygon.polygon

func GenerateOutline() -> void:
	mainSprite.get_parent().add_child(Geometry2DHelper.CreateOutlineFromPolygon(boundingPolygon.polygon, 1.5))

