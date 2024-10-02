@tool
extends Line2D
@export var updatePoints:bool
@export var resetToDefault:bool
@export var originalPointData:PackedVector2Array
@export var mirrorVector:Vector2 = Vector2(1,-1)
@export var mirrorPointRange:Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(resetToDefault):
		resetToDefault = false
		points = originalPointData
	if(updatePoints):
		if(originalPointData.size() == 0):
			originalPointData = points.duplicate()
		updatePoints = false
		var newPointData:PackedVector2Array = points.slice(mirrorPointRange.x, mirrorPointRange.y + 1)
		var mirrorData:PackedVector2Array = []
		for i:int in range(mirrorPointRange.x, mirrorPointRange.y + 1):
			mirrorData.append(points[i] * mirrorVector)
		mirrorData.reverse()
		newPointData.append_array(mirrorData)
		points = newPointData
	pass
