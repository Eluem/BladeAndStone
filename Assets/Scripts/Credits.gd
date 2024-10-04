extends CanvasLayer
var timerEnableBackToMainMenu:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timerEnableBackToMainMenu += delta


func on_click_main_menu() -> void:
	GameStateManager.BeginFadeToScene(GameStateManager.SceneType.MainMenu)
