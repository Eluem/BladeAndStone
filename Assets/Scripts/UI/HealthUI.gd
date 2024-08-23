extends ProgressBar
class_name HealthBar
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func UpdateHealth(_pMaxHealth:int, pHealth:int) -> void:
	value = pHealth
