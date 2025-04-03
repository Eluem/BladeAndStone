extends Node
class_name BossFightManager

@export var mainCamera:CameraMultitracking
@export var boss:BossEnemyRamBeam
@export var playerSpawner:PlayerSpawner

@onready var bossIntroAnim:AnimationPlayer = $BossIntroAnim
@onready var transitionalCamera:Camera2D = $TransitionalCamera
@onready var bossIntroCamera:Camera2D = $BossIntroCamera

var isBossRoomEntered:bool
var isTransitonCameraDone:bool
var isBossDead:bool
var outroFinished:bool
var transitionCameraTimer:float = 0
var outroDelay:float = 8
var bossChunk:RigidBody2D
var bossHeatCollected:bool = false

func _ready() -> void:
	boss.exploded.connect(boss_exploded)
	boss.bossFightManager = self

func _process(delta:float) -> void:
	HandleTransitionCamera(delta)
	HandleOutroDelay(delta)
	#if(isTransitonCameraDone):
		#boss.isDummyMode = false
		#pass


func BossRoomEntered() -> void:
	DeleteNonBossEnemies()
	var player:Golem = GetPlayer()
	isBossRoomEntered = true
	player.inputHandler.Disable()
	player.animationTree.clear_buffers()
	player.animationTree.JumpToIdle()
	player.linear_velocity = Vector2.ZERO
	player.targetRotation = deg_to_rad(-90)
	transitionalCamera.global_position = mainCamera.global_position
	transitionalCamera.zoom = mainCamera.zoom
	transitionalCamera.enabled = true
	transitionalCamera.make_current()


func HandleTransitionCamera(pDelta:float) -> void:
	if(!isBossRoomEntered || isTransitonCameraDone):
		return
	transitionCameraTimer += pDelta*0.5
	if(transitionCameraTimer >= 1):
		transitionCameraTimer = 1
		isTransitonCameraDone = true
		PlayBossIntro()
	transitionalCamera.global_position = lerp(transitionalCamera.global_position, bossIntroCamera.global_position, transitionCameraTimer)
	transitionalCamera.zoom = lerp(transitionalCamera.zoom, bossIntroCamera.zoom, transitionCameraTimer)


func PlayBossIntro() -> void:
	mainCamera.SetLimitBounds(-4974, -10475, -3072, 4125)
	transitionalCamera.enabled = false
	bossIntroCamera.enabled = true
	bossIntroCamera.make_current()
	bossIntroAnim.play("BossIntro")
	bossIntroAnim.animation_finished.connect(intro_camera_animation_finished)


func HandleOutroDelay(pDelta:float) -> void:
	if(!isBossDead):
		return
	#bossFightCameraTarget.global_position = ((bossChunk.global_position - GetPlayer().global_position) / 2) + GetPlayer().global_position
	if(outroFinished):
		return
	outroDelay -= pDelta
	if(!bossHeatCollected && outroDelay < 1):
		outroDelay = 1
	if(outroDelay <= 0):
		outroFinished = true
		GameStateManager.BeginFadeToScene(GameStateManager.SceneType.RunSummary)


func GetPlayer() -> Golem:
	return playerSpawner.currPlayer


func DeleteNonBossEnemies() -> void:
	var enemies:Node2D = $"../Enemies"
	for child:Node in enemies.get_children():
		if(child is not BossEnemyRamBeam && child is not EyeTurret):
			child.queue_free()


func intro_camera_animation_finished(_pAnimName:String) -> void:
	GetPlayer().inputHandler.Enable()
	mainCamera.global_position = bossIntroCamera.global_position
	mainCamera.zoom = bossIntroCamera.zoom
	bossIntroCamera.enabled = false
	boss.TargetFound(GetPlayer())
	mainCamera.zoomRange.x = 0.2
	mainCamera.ignoreDistance = 100000
	
	var bossHealthBar:HealthBar = (CanvasManagerScene as CanvasManager).bossHealthBar
	boss.health_changed.connect(bossHealthBar.UpdateHealth)
	boss.exploded.connect(bossHealthBar.hide.unbind(2))
	bossHealthBar.UpdateHealth(boss.maxHealth, boss.health)
	bossHealthBar.visible = true
	boss.isDummyMode = false
	var musicManager:MusicManager = MusicManagerScene
	musicManager.gameMusic.PlayTrack(musicManager.BOSS_MUSIC)
	#mainCamera.make_current() #redundant, automatically becomes active when all others are false


func boss_exploded(_pChunks:Array[RigidBody2D], _pHitOwner:Node2D) -> void:
	isBossDead = true
	StatTracker.EndRunTimer()


func boss_heart_collected() -> void:
	bossHeatCollected = true
