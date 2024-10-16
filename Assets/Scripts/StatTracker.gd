extends Node

signal score_changed(pScore:int)

var timeMultiplier:float = 0.25
var initialTimeBuffer:float = 30

var currentScore:int = 0
var runStartTime:float = 0
var runCurrTime:float = 0
var damageTaken:int = 0
var damageDealt:int = 0
var enemiesShattered:int = 0

var prevFrameTotalScore:int = 0
var runEnded:bool = false

func _ready() -> void:
	GameStateManager.scene_changed.connect(scene_changed)


func _process(_delta:float) -> void:
	if(!runEnded):
		runCurrTime = Time.get_unix_time_from_system()
	CheckScoreChange()


func CheckScoreChange() -> void:
	var currTotalScore:int = GetTotalScore()
	if(prevFrameTotalScore != currTotalScore):
		score_changed.emit(currTotalScore)
	prevFrameTotalScore = currentScore


#Checks if there's a new high score, updates and saves if there is
#Note: This should only be run after beating the final boss
func CheckForHighScore() -> bool:
	if(GetTotalScore() > GameStateManager.gameData.highScore):
		GameStateManager.gameData.highScore = GetTotalScore()
		GameStateManager.gameData.SaveData()
		return true
	return false


func GetTotalScore() -> int:
	var timePenalty:int = roundi((GetRunTime_Unrounded() - initialTimeBuffer) * timeMultiplier)
	if(timePenalty < 0):
		timePenalty = 0
	var ret:int = currentScore - timePenalty
	if(ret < 0):
		ret = 0
	return ret


func ResetStats() -> void:
	currentScore = 0
	runStartTime = Time.get_unix_time_from_system()
	runCurrTime = 0
	damageTaken = 0
	damageDealt = 0
	enemiesShattered = 0
	prevFrameTotalScore = 0


func EndRunTimer() -> void:
	runEnded = true


func GetRunTime_Unrounded() -> float:
	return runCurrTime - runStartTime


func GetRunTime() -> int:
	return roundi(GetRunTime_Unrounded())


func GetTimeString() -> String:
	var runTime:int = GetRunTime()
	
	if(runTime >= 86400):
		return "lol what?"
	
	var ret:String = ""
	var timeDict:Dictionary = Time.get_time_dict_from_unix_time(runTime)
	
	if(timeDict.hour > 0):
		if(timeDict.hour < 10):
			ret += "0"
		ret += str(timeDict.hour) + ":"
	if(timeDict.minute < 10):
		ret += "0"
	ret += str(timeDict.minute) + ":"
	if(timeDict.second < 10):
		ret += "0"
	ret += str(timeDict.second)

	return ret


func scene_changed(_pNewScene:Node, pSceneType:GameStateManager.SceneType) -> void:
	if(pSceneType == GameStateManager.SceneType.RunSummary):
		return
	ResetStats()


func character_took_damage(pDamage:int, pHitOwner:Node2D, pHitReceiver:Node2D) -> void:
	if(pHitOwner is Golem):
		damageDealt += pDamage
	elif(pHitReceiver is Golem):
		damageTaken += pDamage


func character_exploded(_pChunks:Array[RigidBody2D], pHitOwner:Node2D, pHitReceiver:Node2D) -> void:
	if(pHitOwner is Golem && pHitReceiver is not Golem):
		enemiesShattered += 1


func gem_collected(pValue:int, _pType:Gem.GemType) -> void:
	currentScore += pValue
