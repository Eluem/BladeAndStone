extends CanvasLayer
class_name CanvasManager

const PAUSE_MENU:PackedScene = preload("res://Assets/GameScenes/PauseMenu.tscn")

@onready var HUD:Control = $HUD
@onready var deathOverlay:Control = $DeathOverlay
@onready var pauseButton:TextureButton = $HUD/HBoxContainer/PauseButton
@onready var buttonPressSFX:AudioStreamPlayer = $ButtonPressSFX
@onready var togglePressSFX:AudioStreamPlayer = $TogglePressSFX
@onready var sliderDragSFX:AudioStreamPlayer = $SliderDragSFX

var currPauseMenu:PauseMenu
var deathSequenceTimer:float
var playerDied:bool
var deathSequenceFinished:bool

func _ready() -> void:
	GameStateManager.scene_changing.connect(scene_changing)
	pauseButton.pressed.connect(pause_pressed)


func _process(delta:float) -> void:
	ProcessDeathSequence_SoulsLike(delta)
	#ProcessDeathSequence(delta)


func _input(event: InputEvent) -> void:
	if(!visible):
		return
	if(event.is_action_pressed("ui_cancel")):
		get_viewport().set_input_as_handled()
		pause_pressed()


func ConnectToNewPlayer(pPlayer:Golem) -> void:
	var healthBar:HealthBar = $HUD/HBoxContainer/HealthBar
	pPlayer.health_changed.connect(healthBar.UpdateHealth)
	healthBar.UpdateHealth(pPlayer.maxHealth, pPlayer.health, null)
	
	pPlayer.exploded.connect(player_died)


func player_died(_pMainChunk:Array[RigidBody2D], _pHitOwner:Node2D) -> void:
	playerDied = true


func ProcessDeathSequence(pDelta:float) -> void:
	if(playerDied && !deathSequenceFinished):
		deathSequenceTimer += pDelta
		if(deathSequenceTimer >= 5):
			deathSequenceFinished = true
			GameStateManager.BeginFadeToScene(GameStateManager.SceneType.Game, GameStateManager.usingCheckPoint)


func ProcessDeathSequence_SoulsLike(pDelta:float) -> void:
	if(playerDied && !deathSequenceFinished):
		deathSequenceTimer += pDelta
		deathOverlay.modulate.a = clampf(deathSequenceTimer - 4, 0, 1)
		if(deathSequenceTimer >= 7):
			deathSequenceFinished = true
			GameStateManager.BeginFadeToScene(GameStateManager.SceneType.Game, GameStateManager.usingCheckPoint)


func ResetDeathSequence() -> void:
	deathSequenceTimer = 0
	deathOverlay.modulate.a = 0
	deathSequenceFinished = false
	playerDied = false


func scene_changing(pSceneType:GameStateManager.SceneType) -> void:
	ResetDeathSequence()
	visible = (pSceneType == GameStateManager.SceneType.Game)


func OpenPauseMenu() -> void:
	if(currPauseMenu != null):
		push_error("Pause menu already open!")
	
	currPauseMenu = PAUSE_MENU.instantiate()
	add_child(currPauseMenu)
	currPauseMenu.owner = self


func ClosePauseMenu() -> void:
	currPauseMenu.Close()


func pause_pressed() -> void:
	buttonPressSFX.play()
	GameStateManager.Pause()
