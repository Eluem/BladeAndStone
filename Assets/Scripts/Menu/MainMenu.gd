extends CanvasLayer
class_name MainMenu

const CONFIRMATION_DIALOGUE = preload("res://Assets/GameScenes/ConfirmationDialogue.tscn")
const SETTINGS_MENU = preload("res://Assets/GameScenes/SettingsMenu.tscn")

@onready var continueButton:Button = $PanelContainer/VBoxContainer/ContinueButton
@onready var newGameButton: Button = $PanelContainer/VBoxContainer/NewGameButton
@onready var settingsButton:Button = $PanelContainer/VBoxContainer/SettingsButton
@onready var creditsButton:Button = $PanelContainer/VBoxContainer/CreditsButton
@onready var quitButton:Button = $PanelContainer/VBoxContainer/QuitButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(GameStateManager.gameData.isFirstRun):
		GameStateManager.gameData.isFirstRun = false
		GameStateManager.gameData.SaveData()
	continueButton.pressed.connect(continue_button_pressed)
	newGameButton.pressed.connect(new_game_button_pressed)
	settingsButton.pressed.connect(settings_button_pressed)
	creditsButton.pressed.connect(credits_button_pressed)
	quitButton.pressed.connect(quit_button_pressed)
	
	if(GameStateManager.gameData.checkPointReached):
		continueButton.disabled = false


func continue_button_pressed() -> void:
	GameStateManager.SceneChange(GameStateManager.SceneType.Game, true)


func new_game_button_pressed() -> void:
	if(GameStateManager.gameData.checkPointReached):
		var dialogue:ConfirmationDialogue = CONFIRMATION_DIALOGUE.instantiate()
		dialogue.Initialize(self, lose_check_point_dialogue_response, "Are you sure you want to start a new game and lose your checkpoint?")
	else:
		GameStateManager.SceneChange(GameStateManager.SceneType.Game)


func settings_button_pressed() -> void:
	var settingsMenu:SettingsMenu = SETTINGS_MENU.instantiate()
	settingsMenu.Initialize(self, settings_menu_response, GameStateManager.gameData.GetValues())


func credits_button_pressed() -> void:
	GameStateManager.BeginFadeToScene(GameStateManager.SceneType.Credits)


func quit_button_pressed() -> void:
	var dialogue:ConfirmationDialogue = CONFIRMATION_DIALOGUE.instantiate()
	dialogue.Initialize(self, quit_dialogue_response, "Are you sure you want to quit?")


func lose_check_point_dialogue_response(pResponse:bool) -> void:
	if(!pResponse):
		return
	GameStateManager.gameData.checkPointReached = false
	GameStateManager.gameData.SaveData()
	GameStateManager.SceneChange(GameStateManager.SceneType.Game)


func quit_dialogue_response(pResponse:bool) -> void:
	if(!pResponse):
		return
	GameStateManager.QuitGame()


func settings_menu_response(pResponse:Dictionary) -> void:
	GameStateManager.gameData.SetValues(pResponse)
	GameStateManager.gameData.SaveData()
