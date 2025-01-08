extends Node2D
class_name SmasherVisualEffect

@onready var attackChargeVFX:Sprite2D = $AttackChargeVfx

var attackChargePercentage:float = 0
var unchargeColor:Color =  Color8(170, 0, 0, 0)
var fullChargeColor:Color = Color8(170, 0, 0, 161)
var tipPolygons:Array[Polygon2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	var currColor:Color = unchargeColor.lerp(fullChargeColor, attackChargePercentage)
	if(attackChargePercentage >= 1):
		currColor = Color.WHITE
		currColor.a = 0.4
	
	attackChargeVFX.modulate = currColor
	

#func _draw() -> void:
	#var currColor:Color = unchargeColor.lerp(fullChargeColor, attackChargePercentage)
	#if(attackChargePercentage >= 1):
		#currColor = Color.WHITE
		#currColor.a = 0.4
	##var currRadius:float = 5 * attackChargePercentage
	#
	#for tipPolygon:Polygon2D in tipPolygons:
		#draw_colored_polygon(tipPolygon.polygon, currColor)
	##draw_circle(($RaycastCollider/RaycastNode as Node2D).position, currRadius, currColor)
	##draw_circle(($RaycastCollider/RaycastNode2 as Node2D).position, currRadius, currColor)
	##draw_circle(($RaycastCollider/RaycastNode3 as Node2D).position, currRadius, currColor)
	##draw_circle(($RaycastCollider/RaycastNode4 as Node2D).position, currRadius, currColor)
	##draw_circle(($RaycastCollider/RaycastNode5 as Node2D).position, currRadius, currColor)
	##draw_circle(($RaycastCollider/RaycastNode6 as Node2D).position, currRadius, currColor)
	##draw_circle(($RaycastCollider/RaycastNode7 as Node2D).position, currRadius, currColor)

func UpdateAttackChargePercentage(pAttackChargePercentage:float) -> void:
	if(pAttackChargePercentage != attackChargePercentage):
		attackChargePercentage = pAttackChargePercentage
		queue_redraw()

func PopulateTipPolygons(pMainPolygon:Polygon2D) -> void:
	tipPolygons.append(GenerateTipPolygon(pMainPolygon, ($RaycastCollider/RaycastNode as Node2D).transform))
	tipPolygons.append(GenerateTipPolygon(pMainPolygon, ($RaycastCollider/RaycastNode2 as Node2D).transform))
	tipPolygons.append(GenerateTipPolygon(pMainPolygon, ($RaycastCollider/RaycastNode3 as Node2D).transform))
	tipPolygons.append(GenerateTipPolygon(pMainPolygon, ($RaycastCollider/RaycastNode4 as Node2D).transform, 1))
	tipPolygons.append(GenerateTipPolygon(pMainPolygon, ($RaycastCollider/RaycastNode5 as Node2D).transform))
	tipPolygons.append(GenerateTipPolygon(pMainPolygon, ($RaycastCollider/RaycastNode6 as Node2D).transform, 1))
	tipPolygons.append(GenerateTipPolygon(pMainPolygon, ($RaycastCollider/RaycastNode7 as Node2D).transform))

func GenerateTipPolygon(pMainPolygon:Polygon2D, pTipXForm:Transform2D, pIndex:int = 0) -> Polygon2D:
	var ret:Polygon2D = Polygon2D.new()
	var slicerPolygon:PackedVector2Array = [Vector2(10,10),Vector2(-10,10),Vector2(-10,-10),Vector2(10,-10)]
	slicerPolygon =  pTipXForm * slicerPolygon
	
	var retPolygonData:PackedVector2Array = Geometry2D.intersect_polygons(pMainPolygon.polygon, slicerPolygon)[pIndex]
	ret.polygon = retPolygonData
	return ret
