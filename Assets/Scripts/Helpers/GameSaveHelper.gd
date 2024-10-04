class_name GameSaveHelper
var checkPointReached:bool = false
var musicVolume:float = 0.5
var sfxVolume:float = 0.5
var invertInputDirection:bool = false


func SaveData() -> void:
	var file:FileAccess = FileAccess.open("data.dat", FileAccess.WRITE)
	var data:Dictionary = {
						 "checkPointReached":checkPointReached
						,"musicVolume":musicVolume
						,"sfxVolume":sfxVolume
						,"invertInputDirection":invertInputDirection
					   }
	file.store_var(data, true)
	pass


func LoadData() -> void:
	if(!FileAccess.file_exists("data.dat")):
		return
	var file:FileAccess = FileAccess.open("data.dat", FileAccess.READ)
	var data:Dictionary = file.get_var(true)

	checkPointReached = data.checkPointReached
	musicVolume = data.musicVolume
	sfxVolume = data.sfxVolume
	invertInputDirection = data.invertInputDirection
	pass
