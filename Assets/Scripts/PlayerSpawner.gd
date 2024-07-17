extends Node
@export var HUD:Node
@export var mainCamera:TrackingCamera
var currPlayer:Golem

var spawnPoints:Array[Node2D]
var currSpawnPoint:int = 0
var respawnWaitTime:float = 3
var respawnTimer:float = respawnWaitTime

func _ready() -> void:
	PopulateSpawnPoints()
	
	pass

func _process(delta: float) -> void:
	if(currPlayer == null):
		respawnTimer += delta
		if(respawnTimer >= respawnWaitTime):
			respawnTimer = 0
			currPlayer = SpawnPlayer()

func SpawnPlayer() -> Golem:
	var ret:Golem
	var scene:PackedScene = preload("res://Assets/ObjectScenes/Golem.tscn")
	ret = scene.instantiate()
	ret.global_position = spawnPoints[currSpawnPoint].position
	ret.rotation = spawnPoints[currSpawnPoint].rotation
	var healthBar:HealthBar = (HUD.get_node("HealthBar") as HealthBar)
	ret.connect("health_changed", healthBar.UpdateHealth)
	healthBar.UpdateHealth(ret.health)
	get_tree().root.get_child(0).add_child(ret)
	mainCamera.SetTrackTarget(ret)
	return ret

func PopulateSpawnPoints() -> void:
	spawnPoints = []
	for node in get_children():
		if(node is Node2D):
			spawnPoints.append(node as Node2D)
