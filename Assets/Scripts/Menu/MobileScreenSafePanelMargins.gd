extends PanelContainer

func _ready() -> void:
	if(OS.has_feature("android")):
		UpdateTopMargin()

func UpdateTopMargin() -> void:
	var styleBox:StyleBox = get_theme_stylebox("panel")
	styleBox.content_margin_top += DisplayServer.get_display_safe_area().position.y
