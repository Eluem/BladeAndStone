extends RichTextLabel

func _ready() -> void:
	if(OS.has_feature("android")):
		UpdateFontSize()

func UpdateFontSize() -> void:
	add_theme_font_size_override("normal_font_size", get_theme_font_size("normal_font_size")*2)
