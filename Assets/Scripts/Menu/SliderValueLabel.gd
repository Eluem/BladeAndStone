extends Label
@export var slider:Slider
@export var minValue:float = 0
@export var maxValue:float = 100
@export var step:float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(slider == null):
		slider = get_parent()
	slider.value_changed.connect(slider_value_changed)
	SetValue(slider.value)


func slider_value_changed(pValue:float) -> void:
	SetValue(pValue)


func SetValue(pValue:float) -> void:
	pValue = lerpf(minValue, maxValue, pValue)
	pValue = snappedf(pValue, step)
	text = str(pValue)
