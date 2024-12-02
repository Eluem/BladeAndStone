extends Node

signal scene_changing(pSceneType:SceneType)
signal scene_changed(pNewScene:Node, pSceneType:SceneType)
signal scene_ready(pNewScene:Node, pSceneType:SceneType)

enum SceneType
{
	BootSplash
	,MainMenu
	,Game
	,RunSummary
	,Credits
}

#@onready var currentScene:Node2D = get_tree().current_scene
#@onready var canvasManager:CanvasManager = ManagerScene

var gameData:GameSaveHelper = GameSaveHelper.new()

var sceneList:Array[String] = [
							"res://Assets/GameScenes/BootSplash.tscn"
							,"res://Assets/GameScenes/MainMenu.tscn"
							,"res://Assets/GameScenes/VerticalSlice.tscn"
							,"res://Assets/GameScenes/RunSummary.tscn"
							,"res://Assets/GameScenes/Credits.tscn"
							]

var usingCheckPoint:bool = false
var fading:int = 0
var fadeOutSpeed:float = 1
var fadeInSpeed:float = 1
var skipFadeIn:bool = false
var fadeAmount:float = 0
var fadeTargetSceneType:SceneType
var fadeBlackness:ColorRect
var fadeBlacknessCanvasLayer:CanvasLayer
var fadeUsingCheckPoint:bool = false
var sceneChanging:bool = false
var currentSceneType:SceneType

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	InitializeFadeToBlack()
	gameData.LoadData()


func _process(delta:float) -> void:
	if(Input.is_key_pressed(KEY_A)):
		SceneChange(SceneType.Game, true)
		#BeginFadeToScene(SceneType.Game, true)
	if(Input.is_key_pressed(KEY_S)):
		SceneChange(SceneType.MainMenu)
	if(Input.is_key_pressed(KEY_D)):
		SceneChange(SceneType.Credits)
	ProcessFadeTransition(delta)


func Pause() -> void:
	get_tree().paused = true
	(CanvasManagerScene as CanvasManager).OpenPauseMenu()


func Unpause() -> void:
	get_tree().paused = false
	(CanvasManagerScene as CanvasManager).ClosePauseMenu()


func QuitGame() -> void:
	await((CanvasManagerScene as CanvasManager).buttonPressSFX.finished)
	get_tree().quit()


func SceneChange(pSceneType:SceneType, pUsingCheckPoint:bool = false) -> void:
	_SceneChange.bind(pSceneType, pUsingCheckPoint).call_deferred()


func _SceneChange(pSceneType:SceneType, pUsingCheckPoint:bool = false) -> void:
	if(get_tree().paused):
		Unpause()
	sceneChanging = true
	usingCheckPoint = pUsingCheckPoint
	
	#This seems to start running the new scene earlier than the built in
	#change_scene_to_file method, trying to figure out how to make it work more
	#similarly
	#currentScene.free()
	#var scene:PackedScene = ResourceLoader.load(sceneList[pSceneType])
	#currentScene = scene.instantiate()
	#
	#var tree:SceneTree = get_tree()
	#tree.root.add_child(currentScene)
	#tree.current_scene = currentScene
	#scene_changed.emit(pSceneType, currentScene)
	
	get_tree().change_scene_to_file(sceneList[pSceneType])
	scene_changing.emit(pSceneType)
	currentSceneType = pSceneType
	get_tree().node_added.connect(EmitSceneChangedDelayed.bind(pSceneType))
	#_emit_scene_change.bind(pSceneType).call_deferred()


func BeginFadeToScene(pSceneType:SceneType, pUsingCheckPoint:bool = false, pFadeOutSpeed:float = 1, pFadeInSpeed:float = 1, pSkipFadeOut:bool = false, pSkipFadeIn:bool = false) -> void:
	fadeTargetSceneType = pSceneType
	fadeUsingCheckPoint = pUsingCheckPoint
	fadeOutSpeed = pFadeOutSpeed
	fadeInSpeed = pFadeInSpeed
	fading = 1
	skipFadeIn = pSkipFadeIn
	if(pSkipFadeOut):
		fadeAmount = 1


func ProcessFadeTransition(pDelta:float) -> void:
	if(fading == 1):
		fadeAmount += pDelta * fadeOutSpeed
		fadeBlackness.color.a = fadeAmount
		if(fadeAmount >= 1):
			if(skipFadeIn):
				fading = 0
				fadeAmount = 0
				fadeBlackness.color.a = 0
			else:
				fading = -1
			SceneChange(fadeTargetSceneType, fadeUsingCheckPoint)
	if(fading == -1):
		fadeAmount -= pDelta * fadeInSpeed
		fadeBlackness.color.a = fadeAmount
		if(fadeAmount <= 0):
			fading = 0


func StopFade() -> void:
	fading = 0
	fadeAmount = 0
	fadeBlackness.color.a = 0


func InitializeFadeToBlack() -> void:
	fadeBlacknessCanvasLayer = CanvasLayer.new()
	fadeBlacknessCanvasLayer.layer = 1000
	fadeBlackness = ColorRect.new()
	fadeBlackness.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fadeBlackness.color = Color.BLACK
	fadeBlackness.color.a = 0
	fadeBlackness.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(fadeBlacknessCanvasLayer)
	fadeBlacknessCanvasLayer.add_child(fadeBlackness)


func EmitSceneChangedDelayed(pScene:Node, pSceneType:SceneType) -> void:
	sceneChanging = false
	var sceneTree:SceneTree = get_tree()
	if(pScene != sceneTree.current_scene):
		push_error("Scene change desync! (" + str(pScene) + " != " + str(sceneTree.current_scene))
	sceneTree.node_added.disconnect(EmitSceneChangedDelayed)
	scene_changed.emit(sceneTree.current_scene, pSceneType)
	sceneTree.current_scene.ready.connect(_scene_ready.bind(sceneTree.current_scene, pSceneType))


func _scene_ready(pScene:Node, pSceneType:SceneType) -> void:
	scene_ready.emit(pScene, pSceneType)


func SetMasterVolume(pValue:float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(pValue))


func SetMusicVolume(pValue:float) -> void:
	AudioServer.set_bus_volume_db(1, linear_to_db(pValue))


func SetSFXVolume(pValue:float) -> void:
	AudioServer.set_bus_volume_db(2, linear_to_db(pValue))

##Plays pAudioStream at pPosition, duplicating pAudioStreamPlayer if it's passed
func PlaySFX(pPosition:Vector2, pAudioStream:AudioStream = null, pAudioStreamPlayer:AudioStreamPlayer2D = null, pBus:StringName = &"SFX", pVolumedB:float = 0) -> void:
	var sfxPlayer:AudioStreamPlayer2D
	if(pAudioStreamPlayer == null):
		sfxPlayer = AudioStreamPlayer2D.new()
		sfxPlayer.bus = pBus
		sfxPlayer.volume_db = pVolumedB
	else:
		sfxPlayer = pAudioStreamPlayer.duplicate()
	if(pAudioStream != null):
		sfxPlayer.stream = pAudioStream
	if(sfxPlayer.stream == null):
		return
	get_tree().current_scene.add_child(sfxPlayer)
	sfxPlayer.global_position = pPosition
	sfxPlayer.finished.connect(sfxPlayer.queue_free)
	sfxPlayer.play()
