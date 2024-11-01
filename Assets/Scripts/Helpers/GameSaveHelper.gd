class_name GameSaveHelper
var checkPointReached:bool = false
var masterVolume:float = 0.5
var musicVolume:float = 0.5
var sfxVolume:float = 0.5
var invertInputDirection:bool = false
var isFirstRun:bool = true
var highScore:int = 0


func SaveData() -> void:
	var file:FileAccess = FileAccess.open("data.dat", FileAccess.WRITE)
	var data:Dictionary = GetValues()
	file.store_var(data, true)


func LoadData() -> void:
	if(!FileAccess.file_exists("data.dat")):
		return
	var file:FileAccess = FileAccess.open("data.dat", FileAccess.READ)
	var data:Dictionary = file.get_var(true)
	SetValues(data)


func GetValues() -> Dictionary:
	var ret:Dictionary = {
							 "checkPointReached":checkPointReached
							,"masterVolume":masterVolume
							,"musicVolume":musicVolume
							,"sfxVolume":sfxVolume
							,"invertInputDirection":invertInputDirection
							,"isFirstRun":isFirstRun
							,"highScore":highScore
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
