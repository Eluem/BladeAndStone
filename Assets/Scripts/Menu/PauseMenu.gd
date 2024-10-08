extends Control

const CONFIRMATION_DIALOGUE:PackedScene = preload("res://Assets/GameScenes/ConfirmationDialogue.tscn")
const SETTINGS_MENU:PackedScene = preload("res://Assets/GameScenes/SettingsMenu.tscn")

@onready var closeButton:TextureButton = $CloseButton
@onready var resumeButton: Button = $VBoxContainer/ResumeButton
@onready var settingsButton: Button = $VBoxContainer/SettingsButton
@onready var mainMenuButton: Button = $VBoxContainer/MainMenuButton
@onready var quitButton: Button = $VBoxContainer/QuitButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	closeButton.pressed.connect(resume_pressed)
	resumeButton.pressed.connect(resume_pressed)
	settingsButton.pressed.connect(settings_pressed)
	mainMenuButton.pressed.connect(main_menu_pressed)
	quitButton.pressed.connect(quit_pressed)


func resume_pressed() -> void:
	GameStateManager.Unpause()


func settings_pressed() -> void:
	var settingsMenu:SettingsMenu = SETTINGS_MENU.instantiate()
	settingsMenu.Initialize(self, settings_menu_response, GameStateManager.gameData.GetValues())


func main_menu_pressed() -> void:
	var dialogue:ConfirmationDialogue = CONFIRMATION_DIALOGUE.instantiate()
	dialogue.Initialize(self, main_menu_dialogue_response, "Are you sure you want to quit to the main menu and lose all progress since the last check point?")


func quit_pressed() -> void:
	var dialogue:ConfirmationDialogue = CONFIRMATION_DIALOGUE.instantiate()
	dialogue.Initialize(self, quit_dialogue_response, "Are you sure you want to quit the game and lose all progress since the last check point?")


func main_menu_dialogue_response(pResponse:bool) -> void:
	if(!pResponse):
		return
	GameStateManager.BeginFadeToScene(GameStateManager.SceneType.MainMenu)


func quit_dialogue_response(pResponse:bool) -> void:
	if(!pResponse):
		return
	GameStateManager.QuitGame()


func settings_menu_response(pResponse:Dictionary) -> void:
	GameStateManager.gameData.SetValues(pResponse)
	GameStateManager.gameData.SaveData()
