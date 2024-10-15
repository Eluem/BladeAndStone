extends Node

var currentScore:int = 0
var runTime:float = 0
var damageTaken:int = 0
var damageDealt:int = 0
var enemiesShattered:int = 0

func _ready() -> void:
	GameStateManager.scene_changed.connect(scene_changed)


func _process(delta:float) -> void:
	if(GameStateManager.currentSceneType == GameStateManager.SceneType.Game):
		runTime += delta


#Checks if there's a new high score, updates and saves if there is
#Note: This should only be run after beating the final boss
func CheckForHighScore() -> bool:
	if(currentScore > GameStateManager.gameData.highScore):
		GameStateManager.gameData.highScore = currentScore
		GameStateManager.gameData.SaveData()
		return true
	return false


func ResetStats() -> void:
	currentScore = 0
	runTime = 0
	damageTaken = 0
	damageDealt = 0
	enemiesShattered = 0


func scene_changed(_pNewScene:Node, pSceneType:GameStateManager.SceneType) -> void:
	if(pSceneType == GameStateManager.SceneType.RunSummary):
		return
	ResetStats()
