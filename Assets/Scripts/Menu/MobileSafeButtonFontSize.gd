extends Button

@export var mobileCustomMinimumSizeX:float = -1

func _ready() -> void:
	if(OS.has_feature("android")):
		UpdateFontSize()
		if(mobileCustomMinimumSizeX > custom_minimum_size.x):
			custom_minimum_size.x = mobileCustomMinimumSizeX

func UpdateFontSize() -> void:
	add_theme_font_size_override("font_size", get_theme_font_size("font_size")*2)
