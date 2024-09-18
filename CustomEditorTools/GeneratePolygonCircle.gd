@tool
extends Polygon2D

@export var radius:float = 50:
	get:
		return radius
	set(pValue):
		radius = pValue
		GenerateCircle()
@export var degreesPerPoint:int = 15:
	get:
		return degreesPerPoint
	set(pValue):
		degreesPerPoint = pValue
		GenerateCircle()
@export var initialOffset:float = 0:
	get:
		return initialOffset
	set(pValue):
		initialOffset = pValue
		GenerateCircle()


func GenerateCircle() -> void:
	var newPolyData:PackedVector2Array = []
	
	@warning_ignore("integer_division")
	var steps:int = 360/degreesPerPoint
	
	for i:int in range(steps):
		newPolyData.append((Vector2.RIGHT * radius).rotated(deg_to_rad((i*degreesPerPoint)+initialOffset)))
	
	polygon = newPolyData
