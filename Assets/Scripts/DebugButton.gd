extends Button
var debugInfo:DebugInfo
enum ButtonToggle
{
	Effects,
	Both,
	Debug
}
var buttonHoldTime:float
var buttonToggle:ButtonToggle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	debugInfo = get_tree().get_root().get_node("World2D") as DebugInfo
	connect("button_up", handle_button_up)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(button_pressed):
		buttonHoldTime += delta
		if(buttonHoldTime >= 1):
			get_tree().change_scene_to_file("res://Assets/GameScenes/TestScene.tscn")
			#get_tree().change_scene_to_file("res://Assets/GameScenes/VerticalSlice.tscn")
	else:
		buttonHoldTime = 0

func handle_button_up() -> void:
		if(buttonToggle < 2):
			buttonToggle = ((buttonToggle + 1) as ButtonToggle)
		else:
			buttonToggle = (0 as ButtonToggle)
		match buttonToggle:
			ButtonToggle.Effects:
				debugInfo.effectsEnabled = true
				debugInfo.debugUIEnabled = false
			ButtonToggle.Debug:
				debugInfo.effectsEnabled = false
				debugInfo.debugUIEnabled = true
			ButtonToggle.Both:
				debugInfo.effectsEnabled = true
				debugInfo.debugUIEnabled = true
