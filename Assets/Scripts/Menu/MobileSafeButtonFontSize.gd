extends Button

func _ready() -> void:
	if(OS.has_feature("android")):
		UpdateFontSize()

func UpdateFontSize() -> void:
	add_theme_font_size_override("font_size", get_theme_font_size("font_size")*2)
