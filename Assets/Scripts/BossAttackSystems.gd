extends Node2D
class_name BossAttackSystems
@onready var boss:BossEnemyRamBeam = $".."
@onready var animationPlayerEyes:AnimationPlayer = $"../AnimationPlayerEyes"
@onready var animationPlayerMouth:AnimationPlayer = $"../AnimationPlayerMouth"
@onready var eyeLaserLeft:BossEnemy_EyeLaserProjector = $BossEnemy_EyeLaser_Left
@onready var eyeLaserRight:BossEnemy_EyeLaserProjector = $BossEnemy_EyeLaser_Right
@onready var eyeBeamFiringSFXPlayer:AudioTrack2D = $"../EyeBeamFiringSFXPlayer"
@onready var eyeBlasterFrontLeft:BossEnemy_Eye = $BossEnemy_Eye_FrontLeft
@onready var eyeBlasterFrontRight:BossEnemy_Eye = $BossEnemy_Eye_BackRight
@onready var eyeBlasterBackLeft:BossEnemy_Eye = $BossEnemy_Eye_BackLeft
@onready var eyeBlasterBackRight:BossEnemy_Eye = $BossEnemy_Eye_BackCenter
@onready var eyeBlasterBackCenter:BossEnemy_Eye = $BossEnemy_Eye_BackCenter
@onready var knockbackPulse:KnockbackPulse = $KnockbackPulse


#Debug button down trackers
var keySpaceDown:bool
var keyODown:bool
var keySDown:bool
var keyMDown:bool
var keyCDown:bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	HandleDebugInputs()
	pass


func ChargeFireLasers() -> void:
	animationPlayerEyes.play("BeamChargeFire")


func StopFiringLasers() -> void:
	if(animationPlayerEyes.current_animation == "BeamFiring"):
		animationPlayerEyes.play("BeamStopFiring", 0.5);
		eyeBeamFiringSFXPlayer.FadeTrackOut(1.5);
	elif(animationPlayerEyes.current_animation == "BeamChargeFire"):
		if(!animationPlayerEyes.current_animation_changed.is_connected(WaitToStopFiringBeam)):
			animationPlayerEyes.current_animation_changed.connect(WaitToStopFiringBeam)


#Actually activates the lasers so they run all their code and hit detection
func ActivateLasers() -> void:
	eyeLaserLeft.StartFiring()
	eyeLaserRight.StartFiring()


func DeactivateLasers() -> void:
	eyeLaserLeft.StopFiring()
	eyeLaserRight.StopFiring()


func WaitToStopFiringBeam(_pName:StringName) -> void:
	animationPlayerEyes.current_animation_changed.disconnect(WaitToStopFiringBeam)
	StopFiringLasers()


func FireKnockbackPulse() -> void:
	knockbackPulse.Fire()


func Scream() -> void:
	animationPlayerMouth.play("Mouth_Close")
	animationPlayerMouth.queue("Mouth_Scream")


func InitiatePhaseChange() -> void:
	animationPlayerMouth.play("Mouth_Close")
	animationPlayerMouth.queue("Mouth_Scream_PhaseChange")


func StartChompAttack() -> void:
	animationPlayerMouth.play("Mouth_Close")
	animationPlayerMouth.queue("Attack_Chomp_Open")
	#animationPlayerMouth.queue("Attack_Chomp_Active")
	#animationPlayerMouth.queue("Attack_Chomp_End")


func CanInitiateBigAction() -> bool:
	match animationPlayerMouth.current_animation:
		"Mouth_Scream_PhaseChange", "Mouth_Scream":
			return false
		"Attack_Chomp_Open", "Attack_Chomp_Active", "Attack_Chomp_End":
			return false
	match animationPlayerEyes.current_animation:
		"BeamChargeFire", "BeamFiring", "BeamStopFiring":
			return false
		"OpenEyes":
			return false
	return true


func IsChompAttackActive() -> bool:
	return animationPlayerMouth.current_animation == "Attack_Chomp_Active"


func FireFrontEyeBlasters(pRoundsInBurst:int = 1) -> void:
	eyeBlasterFrontLeft.StartCharging(pRoundsInBurst)
	eyeBlasterFrontRight.StartCharging(pRoundsInBurst)


func FireBackEyeBlasters(pRoundsInBurst:int = 1) -> void:
	eyeBlasterBackLeft.StartCharging(pRoundsInBurst)
	eyeBlasterBackRight.StartCharging(pRoundsInBurst)
	if(boss.isInPhaseTwo):
		eyeBlasterBackCenter.StartCharging(pRoundsInBurst)


func HandleDebugInputs() -> void:
	if(Input.is_key_pressed(KEY_SPACE) && !keySpaceDown):
		print("Space: Disable Me")
		ChargeFireLasers()
		keySpaceDown = true
	elif(!Input.is_key_pressed(KEY_SPACE)):
		keySpaceDown = false
	if(Input.is_key_pressed(KEY_O) && !keyODown):
		print("O: Disable Me")
		animationPlayerEyes.play("OpenEyes")
		keyODown = true
	elif(!Input.is_key_pressed(KEY_O)):
		keyODown = false
	if(Input.is_key_pressed(KEY_S) && !keySDown):
		print("S: Disable Me")
		StopFiringLasers()
		keySDown = true
	elif(!Input.is_key_pressed(KEY_S)):
		keySDown = false
	if(Input.is_key_pressed(KEY_M) && !keyMDown):
		print("M: Disable Me")
		InitiatePhaseChange()
		keyMDown = true
	elif(!Input.is_key_pressed(KEY_M)):
		keyMDown = false
	if(Input.is_key_pressed(KEY_C) && !keyCDown):
		print("C: Disable Me")
		StartChompAttack()
		keyCDown = true
	elif(!Input.is_key_pressed(KEY_C)):
		keyCDown = false
