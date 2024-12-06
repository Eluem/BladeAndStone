extends RigidBody2D
class_name Gem

const GEM_PICKUP_SFX = preload("res://Assets/Audio/GemPickup.wav")
const SMALL_GEM = preload("res://Assets/ObjectScenes/Items/SmallGem.tscn")
const LARGE_GEM = preload("res://Assets/ObjectScenes/Items/LargeGem.tscn")

signal gem_collected(pValue:int, pType:GemType)

enum GemType
{
	 Small
	,Large
}

@onready var pickUpArea:Area2D = $PickUpArea
@onready var autoAttractArea:VisionSensor = $AutoAttractArea
@onready var autoAttractAreaShape:CollisionShape2D = $AutoAttractArea/CollisionShape2D
@onready var physicsCollisionShape:CollisionShape2D = $PhysicsCollisionShape
@onready var pidControllerJoint:PIDControllerJoint2D = $PIDControllerJoint2D

@export var type:GemType = GemType.Small
@export var value:int = 1
@export var canAttract:bool = false:
	get:
		return canAttract
	set(pValue):
		canAttract = pValue
		if(is_node_ready()):
			SyncAutoAttractAreaMonitorMode()
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
	gem_collected.connect(StatTracker.gem_collected)
	pickUpArea.body_entered.connect(pick_up_area_entered)
	autoAttractArea.object_detected.connect(auto_attract_area_enter)
	SyncAutoAttractAreaMonitorMode()


func _process(delta:float) -> void:
	HandleAutoAttractDelay(delta)


func _physics_process(_delta:float) -> void:
	if(pickUpPlayer):
		apply_central_force(global_position.direction_to(pickUpPlayer.global_position) * attractForce)


static func LaunchGems(pSpawner:Node2D, pGems:int, pType:GemType, pAttractRadiusOverride:float = -1, pAttractIgnoreLineOfSight:bool = false) -> void:
	var currentScene:Node = pSpawner.get_tree().current_scene
	var gems:Array[Gem] = []
	match pType:
		GemType.Small:
			for i:int in range(pGems):
				gems.append(SMALL_GEM.instantiate())
		GemType.Large:
			for i:int in range(pGems):
				gems.append(LARGE_GEM.instantiate())
	
	var radialIncrement:float = (2*PI)/pGems
	var initialAngle:float = randf_range(0, PI)
	var currLaunchAngle:float
	var launchVector:Vector2
	
	for i in range(pGems):
		currLaunchAngle = initialAngle + radialIncrement * i
		launchVector = Vector2.from_angle(currLaunchAngle) * GetRandomForce(pType)
		gems[i].canAttract = true
		gems[i].apply_central_impulse(launchVector)
		gems[i].global_position = pSpawner.global_position
		gems[i].autoAttractDelay = 2
		currentScene.add_child(gems[i])
		if(pAttractRadiusOverride >= 0):
			(gems[i].autoAttractAreaShape.shape as CircleShape2D).radius = pAttractRadiusOverride
		gems[i].autoAttractArea.ignoreLineOfSight = pAttractIgnoreLineOfSight


static func GetRandomForce(pType:GemType) -> float:
	match pType:
		GemType.Small:
			return randf_range(200, 400)
		GemType.Large:
			return randf_range(100, 200)
	return 0


func HandleAutoAttractDelay(pDelta:float) -> void:
	if(canAttract && autoAttractDelay > 0):
		autoAttractDelay -= pDelta
		if(autoAttractDelay <= 0):
			SyncAutoAttractAreaMonitorMode()


func SyncAutoAttractAreaMonitorMode() -> void:
	autoAttractArea.monitoring = canAttract && pickUpPlayer == null && autoAttractDelay <= 0


func GemCollected() -> void:
	GameStateManager.PlaySFX(global_position, GEM_PICKUP_SFX)
	gem_collected.emit(value, type)


func pick_up_area_entered(pBody:Node2D) -> void:
	if(pBody is not Golem):
		return
	GemCollected()
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
