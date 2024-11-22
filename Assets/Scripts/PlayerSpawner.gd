extends Node
class_name PlayerSpawner

signal player_spawned(pPlayer:Golem)

@export var mainCamera:CameraMultitracking
var currPlayer:Golem

var spawnPoints:Array[Node2D]
var currSpawnPoint:int = 0
var respawnWaitTime:float = 3
var respawnTimer:float = respawnWaitTime

func _ready() -> void:
	PopulateSpawnPoints()
	currSpawnPoint = GameStateManager.usingCheckPoint
	SpawnPlayer.call_deferred()
	pass


#func _process(delta:float) -> void:
	#if(currPlayer == null):
		#respawnTimer += delta
		#if(respawnTimer >= respawnWaitTime):
			#respawnTimer = 0
			#currPlayer = SpawnPlayer()


func SpawnPlayer() -> Golem:
	var ret:Golem
	var scene:PackedScene = preload("res://Assets/ObjectScenes/Golem.tscn")
	ret = scene.instantiate()
	ret.global_position = spawnPoints[currSpawnPoint].position
	ret.rotation = spawnPoints[currSpawnPoint].rotation
	#GameStateManager.canvasManager.ConnectToNewPlayer(ret)
	CanvasManagerScene.ConnectToNewPlayer(ret)
	
	#get_tree().root.get_child(0).add_child(ret)
	get_tree().current_scene.add_child(ret)
	mainCamera.AddTrackTarget(ret, 20)
	mainCamera.SetMainTarget(ret)
	mainCamera.global_position = ret.global_position
	currPlayer = ret
	player_spawned.emit(ret)
	return ret

func PopulateSpawnPoints() -> void:
	spawnPoints = []
	for node in get_children():
		if(node is Node2D):
			spawnPoints.append(node as Node2D)
