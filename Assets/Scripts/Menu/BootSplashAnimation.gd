extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LicenseHelper.InitLicenseInfo()
	animation_finished.connect(boot_splash_finished)
	play("FadeIn")
	pass # Replace with function body.

func _input(event:InputEvent) -> void:
	if(GameStateManager.gameData.isFirstRun):
		return
	if(event is InputEventMouseButton):
		GameStateManager.SceneChange(GameStateManager.SceneType.MainMenu)
		GameStateManager.StopFade()


func boot_splash_finished(_pAnimName:String) -> void:
	GameStateManager.BeginFadeToScene(GameStateManager.SceneType.MainMenu)
