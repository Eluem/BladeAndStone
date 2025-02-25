extends ScrollContainer
const SETTINGS_MENU_V_SCROLL_THEME = preload("res://Assets/Art/UI/SettingsMenuVScrollTheme.tres")

func _ready() -> void:
	CustomiszeVScrollBar()

func CustomiszeVScrollBar() -> void:
	var scrollBar:VScrollBar = get_v_scroll_bar()
	scrollBar.custom_minimum_size.x = 15
	scrollBar.theme = SETTINGS_MENU_V_SCROLL_THEME
