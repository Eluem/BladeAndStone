@tool
extends Polygon2D

@export var updateColors:bool
@export var resetToDefault:bool
@export var startColor:Color = Color.GREEN
@export var endColor:Color = Color.MAGENTA
@export var originalColorData:PackedColorArray
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	if(resetToDefault):
		resetToDefault = false
		vertex_colors = originalColorData.duplicate()
	if(updateColors):
		updateColors = false
		if(originalColorData.size() == 0):
			originalColorData = vertex_colors.duplicate()
		var newColorData:PackedColorArray = GenerateColors()
		vertex_colors = newColorData


func GenerateColors() -> PackedColorArray:
	var ret:PackedColorArray
	var size:int = polygon.size()
	for i in size:
		#ret.append(startColor.lerp(endColor, (i+1.0)/size))
		if(fmod(float(i), 2.0)):
			ret.append(startColor)
		else:
			ret.append(endColor)
	return ret
