@tool
extends Sprite2D
class_name SpritePolygonGenerator
@export var debugGenerateSpriteExplosion:bool = false
@export var updateSpritePolygonData:bool = false
@export var epsilon:float = 1.0
@export var spritePolygon:Polygon2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_UpdateSpritePolygonData()
	_DebugGenerateSpriteExplosion()
	pass

func _UpdateSpritePolygonData() -> void:
	if(updateSpritePolygonData):
		UpdateSpritePolygonData()
		updateSpritePolygonData = false

func UpdateSpritePolygonData() -> void:
	if(spritePolygon != null):
		spritePolygon.free()
	spritePolygon = Geometry2DHelper.CreatePolygonFromSprite(self, epsilon)[0]
	spritePolygon.visible = false
	get_owner().add_child(spritePolygon)
	spritePolygon.set_owner(get_owner())

func _DebugGenerateSpriteExplosion() -> void:
	if(debugGenerateSpriteExplosion):
		DebugGenerateSpriteExplosion()
		debugGenerateSpriteExplosion = false

func DebugGenerateSpriteExplosion() -> void:
	var chunks:Array[RigidBody2D] = Geometry2DHelper.ExplodeSprite(self, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, spritePolygon)
	for chunk in chunks:
		chunk.reparent(get_owner())
		chunk.set_owner(get_owner())
		chunk.get_child(0).set_owner(get_owner())
