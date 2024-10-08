extends HSlider
class_name CheckButtonSliderGraphic
@export var checkButton:CheckButton
@export var toggleAnimSpeed:float = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(checkButton == null):
		checkButton = get_parent()
	ForceImmediateUpdate()
	if(toggleAnimSpeed < 0):
		checkButton.toggled.connect(check_button_toggled)


func check_button_toggled(pToggledOn:bool) -> void:
	value = pToggledOn


func _process(delta: float) -> void:
	if(toggleAnimSpeed > 0):
		value = move_toward(value, checkButton.button_pressed, delta*toggleAnimSpeed)


func ForceImmediateUpdate() -> void:
	value = checkButton.button_pressed
