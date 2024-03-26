extends Node2D
class_name DebugLine

var startPoint:Vector2
var endPoint:Vector2
var color:Color
var duration:float = 1
var width:float = -1
var antialiased:bool = true

func _init(pStartPoint:Vector2, pEndPoint:Vector2, pColor:Color = Color.GREEN, pDuration:float = 1, pWidth:float = -1, pAntialiased:bool = true) -> void:
	startPoint = pStartPoint
	endPoint = pEndPoint
	color = pColor
	duration = pDuration
	width = pWidth
	antialiased = pAntialiased

static func DrawLine(rootNode:Node, pStartPoint:Vector2, pEndPoint:Vector2, pColor:Color, pDuration:float = 1, pWidth:float = -1, pAntialised:bool = true) -> void:
	rootNode.add_child(DebugLine.new(pStartPoint, pEndPoint, pColor, pDuration, pWidth, pAntialised))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	duration -= delta
	if(duration <= 0):
		queue_free()

func _draw() -> void:
	draw_line(startPoint, endPoint, color, width, antialiased)
