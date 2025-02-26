class_name GameSaveHelper
var checkPointReached:bool = false
var masterVolume:float = 0.8 #0.5
var musicVolume:float = 0.3 #0.5
var sfxVolume:float = 1.0 #0.5
var invertInputDirection:bool = false
var isFirstRun:bool = true
var highScore:int = 0
var windowMode:int = GameStateManager.WindowMode.Fullscreen
var dragSensitivity:float = GetDefaultDragSensitivity()
var dragDeadzone:float = GetDefaultDragDeadzone()
var lookDeadzone:float = GetDefaultLookDeadzone()
var quickTapEnabled:bool = true


func SaveData() -> void:
	var filePath:String
	var file:FileAccess
	if(OS.has_feature("android")):
		filePath = "user://BladeAndStone/data.dat"
		if(!DirAccess.dir_exists_absolute("user://BladeAndStone")):
			DirAccess.make_dir_absolute("user://BladeAndStone")
	else:
		filePath = "./data.dat"
		#filePath = "res://data.dat"
	file = FileAccess.open(filePath, FileAccess.WRITE)
	var data:Dictionary = GetValues()
	file.store_var(data, true)


func LoadData() -> void:
	var filePath:String
	if(OS.has_feature("android")):
		filePath = "user://BladeAndStone/data.dat"
		if(!DirAccess.dir_exists_absolute("user://BladeAndStone")):
			DirAccess.make_dir_absolute("user://BladeAndStone")
	else:
		filePath = "./data.dat"
		#filePath = "res://data.dat"
	if(!FileAccess.file_exists(filePath)):
		SaveData()
	var file:FileAccess = FileAccess.open(filePath, FileAccess.READ)
	var data:Dictionary = file.get_var(true)
	SetValues(data)


static func GetDefaultValues() -> Dictionary:
	var ret:Dictionary = {
							 "checkPointReached":false
							,"masterVolume":0.8
							,"musicVolume":0.3
							,"sfxVolume":1.0
							,"invertInputDirection":false
							,"isFirstRun":true
							,"highScore":0
							,"windowMode":GameStateManager.WindowMode.Fullscreen
							,"dragSensitivity":GetDefaultDragSensitivity()
							,"dragDeadzone":GetDefaultDragDeadzone()
							,"lookDeadzone":GetDefaultLookDeadzone()
							,"quickTapEnabled":true
						 }
	return ret


func GetValues() -> Dictionary:
	var ret:Dictionary = {
							 "checkPointReached":checkPointReached
							,"masterVolume":masterVolume
							,"musicVolume":musicVolume
							,"sfxVolume":sfxVolume
							,"invertInputDirection":invertInputDirection
							,"isFirstRun":isFirstRun
							,"highScore":highScore
							,"windowMode":windowMode
							,"dragSensitivity":dragSensitivity
							,"dragDeadzone":dragDeadzone
							,"lookDeadzone":lookDeadzone
							,"quickTapEnabled":quickTapEnabled
						 }
	return ret


func SetValues(pDictionary:Dictionary) -> void:
	if(pDictionary.has("checkPointReached")):
		checkPointReached = pDictionary.checkPointReached
	if(pDictionary.has("masterVolume")):
		masterVolume = pDictionary.masterVolume
		GameStateManager.SetMasterVolume(masterVolume)
	if(pDictionary.has("musicVolume")):
		musicVolume = pDictionary.musicVolume
		GameStateManager.SetMusicVolume(musicVolume)
	if(pDictionary.has("sfxVolume")):
		sfxVolume = pDictionary.sfxVolume
		GameStateManager.SetSFXVolume(sfxVolume)
	if(pDictionary.has("invertInputDirection")):
		invertInputDirection = pDictionary.invertInputDirection
	if(pDictionary.has("isFirstRun")):
		isFirstRun = pDictionary.isFirstRun
	if(pDictionary.has("highScore")):
		highScore = pDictionary.highScore
	if(pDictionary.has("windowMode")):
		windowMode = pDictionary.windowMode
		GameStateManager.SetWindowMode(windowMode)
	if(pDictionary.has("dragSensitivity")):
		dragSensitivity = pDictionary.dragSensitivity
	if(pDictionary.has("dragDeadzone")):
		dragDeadzone = pDictionary.dragDeadzone
	if(pDictionary.has("lookDeadzone")):
		lookDeadzone = pDictionary.lookDeadzone
	if(pDictionary.has("quickTapEnabled")):
		quickTapEnabled = pDictionary.quickTapEnabled


static func GetDefaultDragSensitivity() -> float:
	if(OS.has_feature("android")):
		return 0.7
	return 0.7


static func GetDefaultDragDeadzone() -> float:
	if(OS.has_feature("android")):
		return 0.8
	return 0.3


static func GetDefaultLookDeadzone() -> float:
	if(OS.has_feature("android")):
		return 0.8
	return 0.3
