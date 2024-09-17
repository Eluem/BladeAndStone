extends Area2D
@onready var bossDoor1:AnimationPlayer = $"../BossDoor/AnimationPlayer"
@onready var bossDoor2:AnimationPlayer = $"../BossDoor2/AnimationPlayer"
@onready var bossDoor3:AnimationPlayer = $"../BossDoor3/AnimationPlayer"
@onready var leftEyeTurret:EyeTurretScanAnimationPlayer = $"../../../Enemies/EyeTurret3/AnimationPlayer"
@onready var rightEyeTurret:EyeTurretScanAnimationPlayer = $"../../../Enemies/EyeTurret4/AnimationPlayer"
@onready var keyHole:Node2D = $KeyHole
@onready var keyHoleAnim:KeyHoleAnimationPlayer = $KeyHole/AnimationPlayer

var alreadyEntered:bool = false
var alreadyExited:bool = false
var player:Golem
var bossKey:BossKey
var bossKeySprite:Sprite2D
#var KeyPIDController:PIDController2D = PIDController2D.new()
var keyScanSuccess:bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#KeyPIDController.frequency = 10
	body_entered.connect(_on_enter)
	body_exited.connect(_on_exit)
	bossDoor2.animation_finished.connect(boss_door2_done)
	leftEyeTurret.animation_finished.connect(successful_scan)
	leftEyeTurret.scanned.connect(scanned)
	keyHoleAnim.key_split.connect(key_split)
	keyHoleAnim.animation_finished.connect(key_inserted)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#if(bossKey && bossKey.PIDControllerJoint.trackDist >= 200):
		#bossKey.PIDControllerJoint.trackDist -= delta*100
	pass


#func _physics_process(delta: float) -> void:
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
		bossKey = player.bossKey
		bossKeySprite = bossKey.sprite
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
	else:
		alreadyEntered = false
		bossDoor1.play("Opening_BounceBack")
		leftEyeTurret.animation_set_next("Deactivate", "Closing")
		rightEyeTurret.animation_set_next("Deactivate", "Closing")
		leftEyeTurret.play("Deactivate")
		rightEyeTurret.play("Deactivate")


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
