extends RigidBody2D
class_name RigidBodyHittable

@onready var hurtSFXPlayer:AudioStreamPlayer2D = $HurtSFXPlayer

@export var maxHealth:int = 100
@export var health:int = maxHealth
@export var invulnerable:bool = false
@export var generateOutline:bool = true
@export var blockLineOfSight:bool = false
@export var blockAttacks:bool = false
@export var smallGemValue:int = 0
@export var largeGemValue:int = 0
@export var hurtSFX:Array[AudioStream]
@export var deathSFX:Array[AudioStream]

#var debugInfo:DebugInfo
var spritePolygon:Polygon2D
var boundingPolygon:Polygon2D
var mainSprite:Sprite2D

signal damage_taken(pDamage:int, pHitOwner:Node2D)
signal health_changed(pMaxHealth:int, pHealth:int, pHitOwner:Node2D)
signal exploded(pChunks:Array[RigidBody2D], pHitOwner:Node2D)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#debugInfo = get_tree().get_root().get_node("World2D") as DebugInfo
	mainSprite = GetMainSprite()
	if(mainSprite is not SpritePolygonGenerator):
		push_error("(Node Name: " + name + ") mainSprite must be a properly configured SpritePolygonGenerator")
	#spritePolygon = Geometry2DHelper.CreatePolygonFromSprite(mainSprite)[0]
	spritePolygon = (mainSprite as SpritePolygonGenerator).spritePolygon
	GenerateBoundingPolygon()
	if(generateOutline):
		GenerateOutline()
	hurtSFXPlayer = get_node_or_null("HurtSFXPlayer")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	pass


func HandleHit(pHitData:HitData) -> void:
	#HitEffect(pHitData.position as Vector2, (pHitData.hitDirection as Vector2).normalized() * (pHitData.knockback as float))
	HitEffect(pHitData.position as Vector2, pHitData.lookDirection.normalized() * (pHitData.knockback as float))
	ApplyKnockback(pHitData.lookDirection as Vector2, pHitData.knockback as float)
	PlayHurtSFX()
	#ApplyDamage(pHitData.hitOwner, pHitData.damage, (pHitData.hitDirection as Vector2).normalized(), pHitData.knockback)
	ApplyDamage(pHitData.hitOwner, pHitData.damage, pHitData.lookDirection.normalized(), pHitData.knockback)


func ApplyDamage(pHitOwner:Node2D, pDamage:int, pDir:Vector2 = Vector2.ZERO, pForce:float = 0) -> void:
	if(invulnerable):
		return
	damage_taken.emit(clamp(pDamage, 0, health), pHitOwner)
	health -= pDamage
	health_changed.emit(maxHealth, health, pHitOwner)
	if(health <= 0):
		Die(pHitOwner, pDir, pForce)


func ApplyHeal(pHeal:int) -> void:
	health += pHeal
	if(health > maxHealth):
		health = maxHealth
	health_changed.emit(maxHealth, health, null)


func ApplyKnockback(pDirection:Vector2, pKnockback:float) -> void:
	apply_central_impulse(pDirection.normalized() * pKnockback)


func HitEffect(pPosition:Vector2, pForce:Vector2) -> void:
	if(DebugInfo.debugUIEnabled):
		DebugLine.DrawLine(get_tree().current_scene, pPosition, pPosition + pForce, Color.WEB_PURPLE, 5, 10)
	if(DebugInfo.effectsEnabled):
		var livingRockHit:LivingRockHit
		livingRockHit = LivingRockHit.Spawn(get_tree().current_scene, pPosition, pForce)
		livingRockHit.z_index = z_index

func PlayHurtSFX() -> void:
	if(hurtSFX.is_empty()):
		return
	var hurtSFXPlayerClone:AudioStreamPlayer2D = hurtSFXPlayer.duplicate()
	get_tree().current_scene.add_child(hurtSFXPlayerClone)
	hurtSFXPlayerClone.global_position = hurtSFXPlayer.global_position
	hurtSFXPlayerClone.stream = hurtSFX.pick_random()
	hurtSFXPlayerClone.finished.connect(hurtSFXPlayerClone.queue_free)
	hurtSFXPlayerClone.play()


func PlayDeathSFX() -> void:
	if(deathSFX.is_empty()):
		return
	var deathSFXPlayer:AudioStreamPlayer2D = hurtSFXPlayer.duplicate()
	get_tree().current_scene.add_child(deathSFXPlayer)
	deathSFXPlayer.global_position = hurtSFXPlayer.global_position
	deathSFXPlayer.stream = deathSFX.pick_random()
	deathSFXPlayer.finished.connect(deathSFXPlayer.queue_free)
	deathSFXPlayer.play()


func Die(pHitOwner:Node2D, pDir:Vector2, pForce:float) -> void:
	var chunks:Array[RigidBody2D] = Geometry2DHelper.ExplodeSprite(mainSprite, pDir, Vector2(pForce*0.5, pForce), Vector2(-pForce/40, pForce/40), spritePolygon, 0, 1)
	if(mainSprite.texture is ViewportTexture):
		var viewportNode:SubViewport = owner.get_node_or_null((mainSprite.texture as ViewportTexture).viewport_path)
		if(viewportNode == null):
			viewportNode = get_node((mainSprite.texture as ViewportTexture).viewport_path)
		viewportNode.reparent(chunks[0])
	
	var gemAttractRadiusOverride:float = -1
	var attractIgnoreLineOfSlight:bool = false
	if(pHitOwner is Golem):
		gemAttractRadiusOverride = 1000
		attractIgnoreLineOfSlight = true
	Gem.LaunchGems(self, smallGemValue, Gem.GemType.Small, gemAttractRadiusOverride, attractIgnoreLineOfSlight)
	Gem.LaunchGems(self, largeGemValue, Gem.GemType.Large, gemAttractRadiusOverride, attractIgnoreLineOfSlight)
	exploded.emit(chunks, pHitOwner)
	PlayDeathSFX()
	queue_free()


func GetMainSprite() -> Sprite2D:
	return $MainSprite


func GenerateBoundingPolygon() -> void:
	boundingPolygon = Polygon2D.new()
	var xForm:Transform2D = Transform2D(mainSprite.rotation, Vector2.ONE, mainSprite.skew, mainSprite.position)
	boundingPolygon.polygon = xForm * spritePolygon.polygon
	#boundingPolygon.polygon = mainSprite.transform.scaled(Vector2(1/mainSprite.scale.y, 1/mainSprite.scale.x)) * spritePolygon.polygon


func GenerateOutline() -> void:
	var outline:Line2D = Geometry2DHelper.CreateOutlineFromPolygon(boundingPolygon.polygon, 1.5)
	mainSprite.get_parent().add_child(outline)
