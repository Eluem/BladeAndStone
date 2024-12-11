extends Node2D
class_name Trail_Polygon

enum AlignmentDirection
{
	Forward,
	Back,
	Left,
	Right
}


@export var color:Color
@export var width:float
@export var widthCurve:Curve
@export var MAX_LENGTH:int
@export var target:Node2D
@export var targetParent:bool = true
@export var maxRemovePerFrame:int = 2
@export var trackingEnabled:bool = true
@export var debugMode:bool = false
@export var polygons:Array[PackedVector2Array]
@export var alignment:AlignmentDirection = AlignmentDirection.Forward

var points:Array[Vector2]
var dirs:Array[Vector2]

func _ready() -> void:
	top_level = true
	if(targetParent):
		target = get_parent()


func _process(_delta:float) -> void:
	UpdateQueue()
	queue_redraw()


func UpdateQueue() -> void:
	if(trackingEnabled):
		points.push_front(target.global_position)
		match alignment:
			AlignmentDirection.Forward:
				dirs.push_front(target.global_transform.x.normalized())
			AlignmentDirection.Back:
				dirs.push_front(-target.global_transform.x.normalized())
			AlignmentDirection.Left:
				dirs.push_front(-target.global_transform.y.normalized())
			AlignmentDirection.Right:
				dirs.push_front(target.global_transform.y.normalized())
	
	var i:int = 0
	while(points.size() > MAX_LENGTH && i < maxRemovePerFrame):
		points.pop_back()
		i+=1
	
	UpdatePolygonData()


func UpdatePolygonData() -> void:
	polygons.clear()
	if(points.size() < 2):
		return
	var outerArc:Array[Vector2]
	var innerArc:Array[Vector2]
	var halfWidth:float
	var pointCount:int = points.size() - 1
	
	for i:int in range(0, points.size()):
		halfWidth = widthCurve.sample(float(i)/pointCount) * width / 2
		outerArc.append((halfWidth * dirs[i]) + points[i])
		innerArc.append((halfWidth * -dirs[i]) + points[i])
	
	var polygon:PackedVector2Array
	for i:int in range(0, points.size()-1):
		polygon = [outerArc[i], outerArc[i+1], innerArc[i]]
		if(Geometry2D.triangulate_polygon(polygon)):
			polygons.append(polygon)
		polygon = [innerArc[i], innerArc[i+1], outerArc[i+1]]
		if(Geometry2D.triangulate_polygon(polygon)):
			polygons.append(polygon)


func Reset() -> void:
	points.clear()


func _draw() -> void:
	for polygon:PackedVector2Array in polygons:
		draw_colored_polygon(polygon, color)
	
	if(debugMode):
		DebugDraw()


func DebugDraw() -> void:
	if(points.size() < 2):
		return
	var perpLinePoint1:Vector2
	var perpLinePoint2:Vector2
	var vect:Vector2
	var midPoint:Vector2
	var perpVect:Vector2
	for i in range(points.size()-1, 0, -1):
		vect = (points[i] - points[i-1])
		midPoint = vect / 2 + points[i-1]
		perpVect.x = -vect.y
		perpVect.y = vect.x
		perpVect = perpVect.normalized() * 50
		perpLinePoint1 = midPoint + perpVect
		perpLinePoint2 = midPoint - perpVect
		draw_line(points[i], points[i-1], Color.BLUE)
		draw_line(midPoint, perpLinePoint1, Color.ORANGE)
		draw_line(midPoint, perpLinePoint2, Color.RED)
