@tool
extends Polygon2D

@export var generateCircle:bool
@export var radius:float = 50
@export var degreesPerPoint:int = 15


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_GenerateCircle()
		
	pass

func _GenerateCircle() -> void:
	if(generateCircle):
		generateCircle = false
		GenerateCircle()


func GenerateCircle() -> void:
	var newPolyData:PackedVector2Array = []
	
	@warning_ignore("integer_division")
	var steps:int = 360/degreesPerPoint
	
	for i:int in range(steps):
		newPolyData.append((Vector2.RIGHT * radius).rotated(deg_to_rad(i*degreesPerPoint)))
	
	polygon = newPolyData
