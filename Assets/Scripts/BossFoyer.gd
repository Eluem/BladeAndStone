extends Area2D
class_name BossFoyer
@export var bossFightManager:BossFightManager

@onready var bossDoor1:AnimationPlayer = $"../BossDoor/AnimationPlayer"
@onready var bossDoor2:AnimationPlayer = $"../BossDoor2/AnimationPlayer"
@onready var bossDoor3:AnimationPlayer = $"../BossDoor3/AnimationPlayer"
@onready var leftEyeTurret:EyeTurretScanAnimationPlayer = $"../../../Enemies/EyeTurret3/AnimationPlayer"
@onready var rightEyeTurret:EyeTurretScanAnimationPlayer = $"../../../Enemies/EyeTurret4/AnimationPlayer"
@onready var keyHole:Node2D = $KeyHole
@onready var keyHoleAnim:KeyHoleAnimationPlayer = $KeyHole/AnimationPlayer
@onready var keyHoleFilledSprite: Sprite2D = $KeyHole/FilledSprite

var alreadyEntered:bool = false
var alreadyExited:bool = false
var player:Golem
var bossKey:BossKey
var keyScanSuccess:bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(GameStateManager.usingCheckPoint):
		ForceCheckPointLoadState()
	
	#KeyPIDController.frequency = 10
	body_entered.connect(_on_enter)
	body_exited.connect(_on_exit)
	bossDoor1.animation_finished.connect(boss_door1_done)
	bossDoor2.animation_finished.connect(boss_door2_done)
	leftEyeTurret.animation_finished.connect(successful_scan)
	leftEyeTurret.scanned.connect(scanned)
	keyHoleAnim.key_split.connect(key_split)
	keyHoleAnim.animation_finished.connect(key_inserted)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	#if(bossKey && bossKey.PIDControllerJoint.trackDist >= 200):
		#bossKey.PIDControllerJoint.trackDist -= delta*100
	pass


#func _physics_process(delta:float) -> void:
	#if(bossKey):# && bossKey.global_position.y > keyHole.global_position.y):
		#KeyPIDController.targetPos = Vector2(bossKey.global_position.x, keyHole.global_position.y)
		#bossKey.apply_central_force(KeyPIDController.Update(delta, bossKey.global_position, bossKey.linear_velocity))


func _on_enter(pBody:PhysicsBody2D) -> void:
	if(pBody is not Golem || alreadyEntered):
		return
	alreadyEntered = true
	
	player = pBody
	
	bossDoor1.play("Closing_BounceBack_LargeFirst")
	
	leftEyeTurret.animation_set_next("Opening", "LeftScan")
	rightEyeTurret.animation_set_next("Opening", "RightScan")
	leftEyeTurret.play("Opening")
	rightEyeTurret.play("Opening")
	
	if(player.hasKey()):
		GameStateManager.gameData.checkPointReached = true
		GameStateManager.gameData.SaveData()
		bossKey = player.bossKey
		leftEyeTurret.animation_set_next("LeftScan", "Closing")
		rightEyeTurret.animation_set_next("RightScan", "Closing")
		#bossKey.apply_central_impulse((keyHole.global_position-bossKey.global_position).normalized()*500)
	else:
		leftEyeTurret.animation_set_next("LeftScan", "Activate")
		rightEyeTurret.animation_set_next("RightScan", "Activate")


func _on_exit(pBody:PhysicsBody2D) -> void:
	if(pBody is not Golem || alreadyExited || pBody.global_position.y > global_position.y):
		return
	if(keyScanSuccess):
		alreadyExited = true
		bossDoor2.play("Closing_BounceBack_LargeFirst")
		bossDoor3.play("Closing_BounceBack_LargeFirst")
		bossFightManager.BossRoomEntered()
	else:
		alreadyEntered = false
		bossDoor1.play("Opening_BounceBack")
		leftEyeTurret.animation_set_next("Deactivate", "Closing")
		rightEyeTurret.animation_set_next("Deactivate", "Closing")
		leftEyeTurret.play("Deactivate")
		rightEyeTurret.play("Deactivate")


func boss_door1_done(pAnimName:String) -> void:
	if(pAnimName != "Closing_BounceBack_LargeFirst"):
		return
	ForceAllEnemiesToLoseTarget()


func boss_door2_done(pAnimName:String) -> void:
	if(pAnimName != "Opening_BounceBack"):
		return
	bossDoor3.play("Opening_BounceBack")


func successful_scan(pAnimName:String) -> void:
	if(pAnimName != "Closing" || !keyScanSuccess):
		return
	keyHoleAnim.play("InsertKey")


func scanned() -> void:
	if(!is_instance_valid(player) || !player.hasKey()):
		return
	keyHoleAnim.play("KeyScanned")

func key_split() -> void:
	keyScanSuccess = true
	bossKey.queue_free()
	player.bossKey = null
	bossKey = null

func key_inserted(pAnimName:String) -> void:
	if(pAnimName != "InsertKey"):
		return
	bossDoor2.play("Opening_BounceBack")


func ForceAllEnemiesToLoseTarget() -> void:
	var enemies:Node2D = $"../../../Enemies"
	for child:Node in enemies.get_children():
		if(child is DashSmashEnemy):
			(child as DashSmashEnemy).TargetLost()
		elif(child is BasicEyeEnemy):
			(child as BasicEyeEnemy).TargetLost()
		elif(child is EyeTurret):
			(child as EyeTurret).TargetLost()


#Forces all boss room entrance details into a post key scan state
func ForceCheckPointLoadState() -> void:
	keyScanSuccess = true
	alreadyEntered = true
	bossDoor1.play("Opening_BounceBack")
	bossDoor1.stop()
	bossDoor2.play("Closing_BounceBack_LargeFirst")
	bossDoor2.stop()
	bossDoor3.play("Closing_BounceBack_LargeFirst")
	bossDoor3.stop()
	keyHoleFilledSprite.visible = true
	keyHoleFilledSprite.z_index = 0
