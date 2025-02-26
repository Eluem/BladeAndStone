extends PanelContainer
@export var sizeMultiplier:Vector2 = Vector2(1.5, 1.5)

func _ready() -> void:
	if(OS.has_feature("android")):
		UpdateSize()

func UpdateSize() -> void:	
	size *= sizeMultiplier
	position = (get_viewport_rect().size / 2) - (size / 2)
