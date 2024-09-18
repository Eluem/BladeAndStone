@tool
extends Line2D
@export var applyShift:bool
@export var resetLineData:bool
@export var shiftAmount:Vector2
@export var originalPointData:PackedVector2Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(resetLineData):
		resetLineData = false
		points = originalPointData
	if(applyShift):
		applyShift = false
		if(originalPointData.size() == 0):
			originalPointData = points
		var xform:Transform2D = Transform2D(0, shiftAmount)
		points *= xform
	pass
