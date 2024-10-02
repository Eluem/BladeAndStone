extends CanvasLayer
#class_name CanvasManager

@onready var HUD:Control = $HUD
@onready var DeathOverlay:Control = $DeathOverlay
@onready var pauseButton: Button = $PauseButton
@onready var pauseMenu: Control = $PauseMenu
@onready var resumeButton: TextureButton = $PauseMenu/ResumeButton


var deathSequenceTimer:float
var playerDied:bool
var deathSequenceFinished:bool

func _ready() -> void:
	GameStateManager.scene_changing.connect(scene_changing)
	pauseButton.pressed.connect(pause_pressed)
	resumeButton.pressed.connect(resume_pressed)

func _process(delta: float) -> void:
	ProcessDeathSequence_SoulsLike(delta)
	#ProcessDeathSequence(delta)


func ConnectToNewPlayer(pPlayer:Golem) -> void:
	var healthBar:HealthBar = $HUD/HealthBar
	pPlayer.health_changed.connect(healthBar.UpdateHealth)
	healthBar.UpdateHealth(pPlayer.maxHealth, pPlayer.health)
	
	pPlayer.exploded.connect(player_died)


func player_died(_pMainChunk:Array[RigidBody2D]) -> void:
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
		DeathOverlay.modulate.a = clampf(deathSequenceTimer - 4, 0, 1)
		if(deathSequenceTimer >= 7):
			deathSequenceFinished = true
			GameStateManager.BeginFadeToScene(GameStateManager.SceneType.Game, GameStateManager.usingCheckPoint)


func ResetDeathSequence() -> void:
	deathSequenceTimer = 0
	DeathOverlay.modulate.a = 0
	deathSequenceFinished = false
	playerDied = false


func scene_changing(pSceneType:GameStateManager.SceneType,) -> void:
	ResetDeathSequence()
	visible = (pSceneType == GameStateManager.SceneType.Game)


func pause_pressed() -> void:
	get_tree().paused = true
	pauseMenu.visible = true


func resume_pressed() -> void:
	get_tree().paused = false
	pauseMenu.visible = false
