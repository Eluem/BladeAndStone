extends Node2D

const BOSS_HEART = preload("res://Assets/ObjectScenes/Items/BossHeart.tscn")

var canvasParent:CanvasLayer

var kPressed:bool = false
var jPressed:bool = false
var pPressed:bool = false
var tPressed:bool = false

var player:Golem

var debugString:String = "":
	get:
		return debugString
	set(value):
		if(debugString != value):
			debugString = value
			queue_redraw()

var debugStringEnabled:bool = false

func _ready() -> void:
	print("Debug Manager Enabled. Disable by going to Project > Project Settings > Globals and deleting it from the list.")
	call_deferred("InitializeCanvasParent")
	
	#Force unlocking the boss check point on game start
	GameStateManager.gameData.checkPointReached = true
	
	process_mode = PROCESS_MODE_ALWAYS
	GameStateManager.scene_ready.connect(on_scene_change)


func _process(_delta:float) -> void:
	_Test()
	_KillAllCreatures()
	_SpawnTestBossHeart()
	_FreezeGame()
	
	#Framerate tracking
	#DebugManager.debugStringEnabled = true
	#DebugManager.debugString = str(Engine.get_frames_per_second())


func _input(event:InputEvent) -> void:
	if(event is InputEventScreenTouch):
		if((event as InputEventScreenTouch).index == 1):
			Test()


func _draw() -> void:
	if(debugStringEnabled):
		DrawString(debugString, get_window().size/2, Color.MAGENTA, 32, HORIZONTAL_ALIGNMENT_CENTER)


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


func _Test() -> void:
	if(Input.is_key_pressed(KEY_T)):
		if(!tPressed):
			Test()
			tPressed = true
	else:
		tPressed = false


#Use this function to put any random test code in
func Test() -> void:
	#print(str(DisplayServer.window_get_size()) + " ||| " + str(DisplayServer.get_display_safe_area().size))
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	#DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	#DisplayServer.window_set_size(DisplayServer.get_display_safe_area().size)
	#DisplayServer.window_set_size(DisplayServer.get_display_safe_area().size)
	#DisplayServer.window_set_position(DisplayServer.get_display_safe_area().position)
	#DisplayServer.window_set_size(Vector2i(100, 100))
	#var viewport:Viewport = get_viewport()
	#$'/root'.set_content_scale_size(Vector2i(100,100))
	#get_viewport().set_content_scale_size(Vector2i(100,100))
	#var viewport:Window = get_viewport()
	#var displaySafeArea:Rect2i = DisplayServer.get_display_safe_area()
	#viewport.size = displaySafeArea.size
	#viewport.position = displaySafeArea.position
	#viewport.position.y += displaySafeArea.size.y
	#DisplayServer.window_set_position(Vector2i(100, 0))
	#var testViewportContainer:SubViewportContainer = SubViewportContainer.new()
	#var testViewport:SubViewport = SubViewport.new()
	#testViewportContainer.size = DisplayServer.get_display_safe_area().size
	#testViewportContainer.position = DisplayServer.get_display_safe_area().position
	#get_tree().root.add_child(testViewportContainer)
	#testViewportContainer.add_child(testViewport)
	#for child in get_tree().root.get_children():
	#	if(child != testViewportContainer):
	#		child.reparent(testViewport)
	#debugString = str(($"../../CanvasManagerScene/HUD" as Control).position) + " ||| " + str(($"../../CanvasManagerScene/HUD" as MobileScreenSafeHUD).displaySafeArea)
	#queue_redraw()
	pass
	
	


func InitializeCanvasParent() -> void:
	canvasParent = CanvasLayer.new()
	canvasParent.layer = 9999999999999
	get_parent().add_child(canvasParent)
	reparent(canvasParent)

func DrawString(pString:String, pPos:Vector2, pColor:Color = Color.MAGENTA, pFontSize:int = 32, pAlignment:HorizontalAlignment = HORIZONTAL_ALIGNMENT_CENTER) -> void:
	var font:Font = ThemeDB.fallback_font
	var pos:Vector2 = pPos
	var stringSize:Vector2 = font.get_string_size(pString, pAlignment, -1, pFontSize)
	match pAlignment:
		HORIZONTAL_ALIGNMENT_CENTER:
			pos.x -= stringSize.x / 2
		HORIZONTAL_ALIGNMENT_LEFT:
			pass #Don't need to do anything here because it's left aligned by defualt
		HORIZONTAL_ALIGNMENT_RIGHT:
			pos.x -= stringSize.x
	pos.y -= stringSize.y / 2
	pos.y += font.get_ascent(pFontSize)
	draw_string(ThemeDB.fallback_font, pos, pString, pAlignment, -1, pFontSize, pColor)
