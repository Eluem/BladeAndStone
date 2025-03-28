extends RigidBody2D
class_name BossHeart

const GEM_PICKUP_SFX = preload("res://Assets/Audio/SFX/GemPickup.wav")
const BOSS_HEART = preload("res://Assets/ObjectScenes/Items/BossHeart.tscn")

signal boss_heart_collected(pPickUpPlayer:Golem)

@onready var pickUpArea:Area2D = $PickUpArea
@onready var autoAttractArea:VisionSensor = $AutoAttractArea
@onready var physicsCollisionShape:CollisionShape2D = $PhysicsCollisionShape
@onready var pidControllerJoint:PIDControllerJoint2D = $PIDControllerJoint2D

@export var value:int = 20
@export var attractForce:float = 800
@export var autoAttractDelay:float

var pickUpPlayer:Golem:
	get:
		return pickUpPlayer
	set(pValue):
		pickUpPlayer = pValue
		pidControllerJoint.trackNode = pickUpPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pickUpArea.body_entered.connect(pick_up_area_entered)
	autoAttractArea.object_detected.connect(auto_attract_area_enter)
	boss_heart_collected.connect(StatTracker.boss_heart_collected.bind(value).unbind(1))
	SpawnConnectedGems()
	SyncAutoAttractAreaMonitorMode()


func _process(delta:float) -> void:
	HandleAutoAttractDelay(delta)


func _physics_process(_delta:float) -> void:
	if(pickUpPlayer):
		apply_central_force(global_position.direction_to(pickUpPlayer.global_position) * attractForce)


static func Spawn(pSpawner:Node2D) -> BossHeart:
	var currentScene:Node = pSpawner.get_tree().current_scene
	var newBossHeart:BossHeart = BOSS_HEART.instantiate()
	newBossHeart.global_position = pSpawner.global_position
	currentScene.add_child(newBossHeart)
	return newBossHeart


func HandleAutoAttractDelay(pDelta:float) -> void:
	if(autoAttractDelay > 0):
		autoAttractDelay -= pDelta
		if(autoAttractDelay <= 0):
			SyncAutoAttractAreaMonitorMode()


func SyncAutoAttractAreaMonitorMode() -> void:
	autoAttractArea.monitoring = pickUpPlayer == null && autoAttractDelay <= 0


func Collected(pPickUpPlayer:Golem) -> void:
	GameStateManager.PlaySFX(global_position, GEM_PICKUP_SFX)
	boss_heart_collected.emit(pPickUpPlayer)


func SpawnConnectedGems() -> void:
	var gems:Array[Gem] = Gem.LaunchGems(self, 30, Gem.GemType.Small, 0, true, false, 0, 4)
	gems.append_array(Gem.LaunchGems(self, 10, Gem.GemType.Large, 0, true, false, 0, 4))
	for gem:Gem in gems:
		boss_heart_collected.connect(gem.auto_attract_area_enter)


func pick_up_area_entered(pBody:Node2D) -> void:
	if(pBody is not Golem):
		return
	Collected(pBody as Golem)
	queue_free()


func auto_attract_area_enter(pBody:Node2D) -> void:
	if(pBody is not Golem):
		return
	pBody.tree_exited.connect(pick_up_player_destroyed)
	pickUpPlayer = pBody
	physicsCollisionShape.disabled = true
	autoAttractArea.monitoring = false


func pick_up_player_destroyed() -> void:
	pickUpPlayer = null
	physicsCollisionShape.disabled = false
	SyncAutoAttractAreaMonitorMode()
