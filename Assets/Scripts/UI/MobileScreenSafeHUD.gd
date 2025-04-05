#Simple bit of code to bump the HUD down for mobile platforms so the HUD doesn't overlap the camera
extends Control
class_name MobileScreenSafeHUDMargin

var displaySafeArea:Rect2i

func _ready() -> void:
	if(OS.has_feature("android")):
		displaySafeArea = DisplayServer.get_display_safe_area()
		#size = displaySafeArea.size
		#position = displaySafeArea.position
		add_theme_constant_override("margin_top", 10 + displaySafeArea.position.y)
		add_theme_constant_override("margin_left", displaySafeArea.position.x)
