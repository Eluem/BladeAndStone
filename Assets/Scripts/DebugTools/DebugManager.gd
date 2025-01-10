extends Node

const BOSS_HEART = preload("res://Assets/ObjectScenes/Items/BossHeart.tscn")

var kPressed:bool = false
var jPressed:bool = false
var pPressed:bool = false

var player:Golem



func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	GameStateManager.scene_ready.connect(on_scene_change)


func _process(_delta:float) -> void:
	_KillAllCreatures()
	_SpawnTestBossHeart()
	_FreezeGame()


func _KillAllCreatures() -> void:
	if(Input.is_key_pressed(KEY_K)):
		if(!kPressed):
			KillAllCreatures()
			kPressed = true
	else:
		kPressed = false


func KillAllCreatures() -> void:
	var nodes:Array[Node] = get_tree().get_nodes_in_group("Enemies")
	var creature:RigidBodyHittable
	for node:Node in nodes:
		if(node is RigidBodyHittable and node is not BossEnemyRamBeam):
			creature = node
			creature.ApplyDamage(null, 10000)


func _SpawnTestBossHeart() -> void:
	if(Input.is_key_pressed(KEY_J)):
		if(!jPressed):
			SpawnTestBossHeart()
			jPressed = true
	else:
		jPressed = false


func SpawnTestBossHeart() -> void:
	var bossHeart:BossHeart = BOSS_HEART.instantiate()
	bossHeart.global_position = player.global_position
	bossHeart.global_position.x += 500
	get_tree().current_scene.add_child(bossHeart)


func _FreezeGame() -> void:
	if(Input.is_key_pressed(KEY_P)):
		if(!pPressed):
			FreezeGame()
			pPressed = true
	else:
		pPressed = false


func FreezeGame() -> void:
	get_tree().paused = !get_tree().paused


func on_scene_change(_pNewScene:Node, pSceneType:GameStateManager.SceneType) -> void:
	if(pSceneType != GameStateManager.SceneType.Game):
		return
	var spawner:PlayerSpawner = get_tree().current_scene.get_node("PlayerManager/Spawner")
	spawner.player_spawned.connect(on_player_spawned)


func on_player_spawned(pPlayer:Golem) -> void:
	player = pPlayer
	#player.exploded.connect(on_player_death)


func on_player_death(_pChunks:Array[RigidBody2D], _pHitOwner:Node2D) -> void:
	SpawnExplosion()


func SpawnExplosion() -> void:
	var currScene:Node2D = get_tree().current_scene
	var damageBox:EyeBolt = EyeBolt.Spawn(currScene, player, player.global_position, Vector2.ZERO)
	print(damageBox.get_collision_exceptions())
	damageBox.AddCollisionException(player)
	print(damageBox.get_collision_exceptions())
	damageBox.damage = 10000
	var collider:BulletWithCCD = damageBox.get_node("Collider")
	print(collider.shape)
	collider.shape = collider.shape.duplicate()
	collider.shapeCast.shape = collider.shape
	(collider.shape as CapsuleShape2D).radius = 1000
	damageBox.destroySelfOnHit = false
