@tool
extends Path2D

@export var bakeLineToPath:bool = false
@export var lineResetOffset:bool = false
@export var bakePolygonToLine:bool = false
@export var bakeCollisionToLine:bool = false

@export var targetLine:Line2D
@export var insideOut:bool = false

@export var targetPolygon:Polygon2D
@export var targetColliderPolygon:CollisionPolygon2D
@export var wallWidth:float = 10
@export var shadowWidth:float = 30


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_BakeLineToPath()
	_ResetOffset()
	_BakePolygonToLine2D()
	_BakeCollisionToLine2D()

func _BakeLineToPath() -> void:
	if(bakeLineToPath):
		BakeLineToPath(self)
		bakeLineToPath = false

func BakeLineToPath(pPath:Path2D) -> void:
	var tempPoints:PackedVector2Array = pPath.curve.get_baked_points()
	targetLine.points = tempPoints

func _ResetOffset() -> void:
	if(lineResetOffset):
		print("Resetting Offset")
		ResetOffset()
		lineResetOffset = false

func ResetOffset() -> void:
	var xForm:Transform2D = Transform2D(0, position)
	if(insideOut):
		targetLine.points = targetLine.points * xForm
	else:
		targetLine.points = xForm * targetLine.points
	#position = Vector2.ZERO

func _BakePolygonToLine2D() -> void:
	if(bakePolygonToLine):
		targetPolygon.polygon = BakePolygonToLine2D(targetLine, shadowWidth)
		bakePolygonToLine = false

func _BakeCollisionToLine2D() -> void:
	if(bakeCollisionToLine):
		targetColliderPolygon.polygon = BakePolygonToLine2D(targetLine, wallWidth)
		bakeCollisionToLine = false

func BakePolygonToLine2D(pLine:Line2D, pWidth:float) -> PackedVector2Array:
	var halfA:PackedVector2Array = []
	var halfB:PackedVector2Array = []
	var finalPolyData:PackedVector2Array
	var perpendicular:Vector2
	var pointCount:int = pLine.points.size()
	var halfWidth:float = pWidth/2.0  #pLine.width/2
	for i in range(pointCount):
		if(i < pointCount-1):
			perpendicular = pLine.points[i + 1] - pLine.points[i]
		elif(pLine.closed):
			perpendicular = pLine.points[1] - pLine.points[i]
			perpendicular = Vector2(perpendicular.y, -perpendicular.x).normalized() * halfWidth
			halfA.append(pLine.points[i] + perpendicular)
			halfB.append(pLine.points[i] - perpendicular)
			perpendicular = pLine.points[2] - pLine.points[1]
			perpendicular = Vector2(perpendicular.y, -perpendicular.x).normalized() * halfWidth
			halfA.append(pLine.points[1] + perpendicular)
			halfB.append(pLine.points[1] - perpendicular)
			continue
		else:
			perpendicular = pLine.points[i] - pLine.points[i-1]
		perpendicular = Vector2(perpendicular.y, -perpendicular.x).normalized() * halfWidth
		halfA.append(pLine.points[i] + perpendicular)
		halfB.append(pLine.points[i] - perpendicular)
	halfB.reverse()
	finalPolyData = halfA
	finalPolyData.append_array(halfB)
	
	return finalPolyData
