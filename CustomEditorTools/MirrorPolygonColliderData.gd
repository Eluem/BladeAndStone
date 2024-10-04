@tool
extends CollisionPolygon2D

@export var updatePoints:bool
@export var resetToDefault:bool
@export var originalPolyData:PackedVector2Array
@export var mirrorVector:Vector2 = Vector2(1,-1)
@export var mirrorPointRange:Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	if(resetToDefault):
		resetToDefault = false
		polygon = originalPolyData
	if(updatePoints):
		if(originalPolyData.size() == 0):
			originalPolyData = polygon.duplicate()
		updatePoints = false
		var newPointData:PackedVector2Array = originalPolyData.duplicate()
		var mirrorData:PackedVector2Array
		var xform:Transform2D = Transform2D(0.0, mirrorVector, 0.0, Vector2.ZERO)
		mirrorData = originalPolyData.slice(mirrorPointRange.x, mirrorPointRange.y + 1) * xform
		mirrorData.reverse()
		newPointData.append_array(mirrorData)
		polygon = newPointData
	pass
