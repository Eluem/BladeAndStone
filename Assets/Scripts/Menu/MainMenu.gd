extends CanvasLayer
class_name MainMenu

const CONFIRMATION_DIALOGUE = preload("res://Assets/GameScenes/ConfirmationDialogue.tscn")
const SETTINGS_MENU = preload("res://Assets/GameScenes/SettingsMenu.tscn")

@onready var continueButton:Button = $PanelContainer/VBoxContainer/ContinueButton
@onready var newGameButton:Button = $PanelContainer/VBoxContainer/NewGameButton
@onready var settingsButton:Button = $PanelContainer/VBoxContainer/SettingsButton
@onready var creditsButton:Button = $PanelContainer/VBoxContainer/CreditsButton
@onready var quitButton:Button = $PanelContainer/VBoxContainer/QuitButton

var konamiCodeDuration:float = 2
var konamiCodeTimer:float
var konamiCodeIndex:int = -1
var konamiCodeSequence:String = "UUDDLRLR" #"UUDDLRLRBAS" (truncated because I don't have a good way to represent B, A, Start right now


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
	
	(MusicManagerScene as MusicManager).gameMusic.PauseTrack()
	(MusicManagerScene as MusicManager).menuMusic.ResumeOrPlayTrack()


func _process(delta:float) -> void:
	UpdateKonamiCodeTimer(delta)


func _input(event:InputEvent) -> void:
	if(event is not InputEventMouseButton):
		return
	var eventCast:InputEventMouseButton = event
	if(!eventCast.pressed || eventCast.button_index != 1 || eventCast.is_echo()):
		return
	var mousePosUV:Vector2 = get_viewport().get_mouse_position() / ((get_viewport() as Window).size as Vector2)
	HandleKonamiCodeInput(GetKonamiCodeInputFromUV(mousePosUV))



func continue_button_pressed() -> void:
	(CanvasManagerScene as CanvasManager).buttonPressSFX.play()
	GameStateManager.SceneChange(GameStateManager.SceneType.Game, true)


func new_game_button_pressed() -> void:
	(CanvasManagerScene as CanvasManager).buttonPressSFX.play()
	if(GameStateManager.gameData.checkPointReached):
		var dialogue:ConfirmationDialogue = CONFIRMATION_DIALOGUE.instantiate()
		dialogue.Initialize(self, lose_check_point_dialogue_response, "Are you sure you want to start a new game and lose your checkpoint?")
	else:
		GameStateManager.SceneChange(GameStateManager.SceneType.Game)


func settings_button_pressed() -> void:
	(CanvasManagerScene as CanvasManager).buttonPressSFX.play()
	var settingsMenu:SettingsMenu = SETTINGS_MENU.instantiate()
	settingsMenu.Initialize(self, settings_menu_response, GameStateManager.gameData.GetValues(), GameSaveHelper.GetDefaultValues())


func credits_button_pressed() -> void:
	(CanvasManagerScene as CanvasManager).buttonPressSFX.play()
	GameStateManager.BeginFadeToScene(GameStateManager.SceneType.Credits)


func quit_button_pressed() -> void:
	(CanvasManagerScene as CanvasManager).buttonPressSFX.play()
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


func UpdateKonamiCodeTimer(pDelta:float) -> void:
	if(konamiCodeTimer > 0):
		konamiCodeTimer -= pDelta
		if(konamiCodeTimer <= 0):
			KonamiCodeFail()


func KonamiCodeFail() -> void:
	if(konamiCodeIndex > -1):
		(CanvasManagerScene as CanvasManager).konamiCodeFail.play()
	konamiCodeTimer = 0
	konamiCodeIndex = -1


func KonamiCodeSuccess() -> void:
	konamiCodeIndex = -1
	konamiCodeTimer = 0
	(CanvasManagerScene as CanvasManager).konamiCodeSuccess.play()
	continueButton.disabled = false
	GameStateManager.gameData.checkPointReached = true
	GameStateManager.gameData.SaveData()


func GetKonamiCodeInputFromUV(pUV:Vector2) -> String:
	#Left
	if(pUV.x <= 0.2 && pUV.y > 0.2 && pUV.y < 0.8):
		return "L"
	#Right
	elif(pUV.x >= 0.8 && pUV.y > 0.2 && pUV.y < 0.8):
		return "R"
	#Up
	elif(pUV.y <= 0.2 && pUV.x > 0.2 && pUV.x < 0.8):
		return "U"
	#Down
	elif(pUV.y >= 0.8 && pUV.x > 0.2 && pUV.x < 0.8):
		return "D"
	return ""


func HandleKonamiCodeInput(pInput:String) -> void:
	konamiCodeIndex += 1
	if(konamiCodeSequence[konamiCodeIndex] == pInput):
		konamiCodeTimer = konamiCodeDuration
		(CanvasManagerScene as CanvasManager).konamiCodeInputCorrect.play()
		if(konamiCodeIndex >= konamiCodeSequence.length() - 1):
			KonamiCodeSuccess()
	else:
		if(konamiCodeIndex == 0):
			konamiCodeIndex = -1
		KonamiCodeFail()
