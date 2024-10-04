extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	pass


"""
static func new_DebugLine(pStartPoint:Vector2, pEndPoint:Vector2, pColor:Color = Color.GREEN, pDuration:float = 1, pWidth:float = -1) -> DebugLine:
	print(pStartPoint)
	print(pEndPoint)
	var newDebugLine:DebugLine = ((load("res://DebugTools/debug_line.tscn") as PackedScene).instantiate() as DebugLine).new(pStartPoint, pEndPoint)
	newDebugLine.startPoint = pStartPoint
	newDebugLine.endPoint = pEndPoint
	newDebugLine.color = pColor
	newDebugLine.duration = pDuration
	newDebugLine.width = pWidth
	return newDebugLine
"""
