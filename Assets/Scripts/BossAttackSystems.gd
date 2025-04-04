extends Node2D
class_name BossAttackSystems
@onready var boss:BossEnemyRamBeam = $".."
@onready var animationPlayerEyes:AnimationPlayer = $"../AnimationPlayerEyes"
@onready var animationPlayerMouth:AnimationPlayer = $"../AnimationPlayerMouth"
@onready var eyeBeamLeft:BossEnemy_EyeBeamProjector = $BossEnemy_EyeBeam_Left
@onready var eyeBeamRight:BossEnemy_EyeBeamProjector = $BossEnemy_EyeBeam_Right
@onready var eyeBeamFiringSFXPlayer:AudioTrack2D = $"../EyeBeamFiringSFXPlayer"
@onready var eyeBlasterFrontLeft:BossEnemy_Eye = $BossEnemy_Eye_FrontLeft
@onready var eyeBlasterFrontRight:BossEnemy_Eye = $BossEnemy_Eye_FrontRight
@onready var eyeBlasterBackLeft:BossEnemy_Eye = $BossEnemy_Eye_BackLeft
@onready var eyeBlasterBackRight:BossEnemy_Eye = $BossEnemy_Eye_BackRight
@onready var eyeBlasterBackCenter:BossEnemy_Eye = $BossEnemy_Eye_BackCenter
@onready var knockbackPulse:KnockbackPulse = $KnockbackPulse


#Debug button down trackers
var debugEnabled:bool = false
var keySpaceDown:bool
var keyODown:bool
var keySDown:bool
var keyMDown:bool
var keyCDown:bool
var keyFDown:bool
var keyBDown:bool
var beamCooldownRange:Vector2 = Vector2(30, 60)
var beamDurationRange:Vector2 = Vector2(13, 18)
var beamCooldownTimer:float
var beamDurationTimer:float
var beamRotationSpeed:float
var backEyeBlasterCooldownRange:Vector2 = Vector2(8, 15)
var backEyeBlasterCooldownRangePhaseTwo:Vector2 = Vector2(5, 10)
var backEyeBlasterCooldownTimer:float
var frontEyeBlasterCooldownRange:Vector2 = Vector2(12, 20)
var frontEyeBlasterCooldownRangePhaseTwo:Vector2 = Vector2(9, 15)
var frontEyeBlasterCooldownTimer:float
var chompCooldownRange:Vector2 = Vector2(6, 12)
var chompCooldownRangePhaseTwo:Vector2 = Vector2(5, 9)
var chompCooldownTimer:float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(debugEnabled):
		push_warning("Boss debug features enabled")
	#Initialize the beam duration to a random time, rerandomizes after each firing
	beamDurationTimer = randf_range(beamDurationRange.x, beamDurationRange.y)
	#Choose a random starting attack
	match randi_range(0, 2):
		0:
			chompCooldownTimer = chompCooldownRange.x
			frontEyeBlasterCooldownTimer = frontEyeBlasterCooldownRange.x
			#GenerateChompCooldown()
			#GenerateFrontEyeBlasterCooldown()
		1:
			chompCooldownTimer = chompCooldownRange.x
			backEyeBlasterCooldownTimer = backEyeBlasterCooldownRange.x
			#GenerateChompCooldown()
			#GenerateBackEyeBlasterCooldown()
		2:
			frontEyeBlasterCooldownTimer = frontEyeBlasterCooldownRange.x
			backEyeBlasterCooldownTimer = backEyeBlasterCooldownRange.x
			#GenerateFrontEyeBlasterCooldown()
			#GenerateBackEyeBlasterCooldown()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	if(boss.isDummyMode):
		return
	UpdateTimers(delta)
	UpdateCooldowns(delta)
	HandleDebugInputs()


func UpdateTimers(pDelta:float) -> void:
	if(IsBeamActive()):
		beamDurationTimer -= pDelta


func UpdateCooldowns(pDelta:float) -> void:
	if(beamCooldownTimer > 0):
		beamCooldownTimer -= pDelta
	if(backEyeBlasterCooldownTimer > 0):
		backEyeBlasterCooldownTimer -= pDelta
	if(frontEyeBlasterCooldownTimer > 0):
		frontEyeBlasterCooldownTimer -= pDelta
	if(chompCooldownTimer > 0):
		chompCooldownTimer -= pDelta


func GenerateBackEyeBlasterCooldown() -> void:
	if(boss.isInPhaseTwo):
		backEyeBlasterCooldownTimer = randf_range(backEyeBlasterCooldownRangePhaseTwo.x, backEyeBlasterCooldownRangePhaseTwo.y)
	else:
		backEyeBlasterCooldownTimer = randf_range(backEyeBlasterCooldownRange.x, backEyeBlasterCooldownRange.y)


func GenerateFrontEyeBlasterCooldown() -> void:
	if(boss.isInPhaseTwo):
		frontEyeBlasterCooldownTimer = randf_range(frontEyeBlasterCooldownRangePhaseTwo.x, frontEyeBlasterCooldownRangePhaseTwo.y)
	else:
		frontEyeBlasterCooldownTimer = randf_range(frontEyeBlasterCooldownRange.x, frontEyeBlasterCooldownRange.y)
	
	
func GenerateChompCooldown() -> void:
	if(boss.isInPhaseTwo):
		chompCooldownTimer = randf_range(chompCooldownRangePhaseTwo.x, chompCooldownRangePhaseTwo.y)
	else:
		chompCooldownTimer = randf_range(chompCooldownRange.x, chompCooldownRange.y)


func IsAnyBlasterBusy() -> bool:
	if(eyeBlasterFrontLeft.IsBusy() || eyeBlasterFrontRight.IsBusy()):
		return true
	if(eyeBlasterBackLeft.IsBusy() || eyeBlasterBackRight.IsBusy()):
		return true
	if(boss.isInPhaseTwo && eyeBlasterBackCenter.IsBusy()):
		return true
	return false


func IsBackEyeBlasterReady() -> bool:
	if(eyeBlasterBackLeft.IsBusy() || eyeBlasterBackRight.IsBusy()):
		return false
	if(boss.isInPhaseTwo && eyeBlasterBackCenter.IsBusy()):
		return false
	return backEyeBlasterCooldownTimer <= 0


func IsFrontEyeBlasterReady() -> bool:
	if(eyeBlasterFrontLeft.IsBusy() || eyeBlasterFrontRight.IsBusy()):
		return false
	return frontEyeBlasterCooldownTimer <= 0


func IsChompReady() -> bool:
	return chompCooldownTimer <= 0


func IsBeamReady() -> bool:
	return beamCooldownTimer <= 0


func IsBeamOutOfTime() -> bool:
	return beamDurationTimer <= 0


func ChargeFireBeams() -> void:
	boss.pidJoint.enabled = true
	boss.lock_rotation = true
	animationPlayerEyes.play("BeamChargeFire")
	beamRotationSpeed = 1 - 2*(randi_range(0, 1))
	beamRotationSpeed *= 0.7 #0.5


func StopFiringBeams() -> void:
	if(animationPlayerEyes.current_animation == "BeamFiring"):
		animationPlayerEyes.play("BeamStopFiring", 0.5);
		eyeBeamFiringSFXPlayer.FadeTrackOut(1.5);
	elif(animationPlayerEyes.current_animation == "BeamChargeFire"):
		if(!animationPlayerEyes.current_animation_changed.is_connected(WaitToStopFiringBeam)):
			animationPlayerEyes.current_animation_changed.connect(WaitToStopFiringBeam)


func BeamFiringEnded() -> void:
	boss.pidJoint.enabled = false
	boss.lock_rotation = false
	beamDurationTimer = randf_range(beamDurationRange.x, beamDurationRange.y)
	beamCooldownTimer = randf_range(beamCooldownRange.x, beamCooldownRange.y)


#Actually activates the beams so they run all their code and hit detection
func ActivateBeams() -> void:
	eyeBeamLeft.StartFiring()
	eyeBeamRight.StartFiring()


func DeactivateBeams() -> void:
	eyeBeamLeft.StopFiring()
	eyeBeamRight.StopFiring()


func WaitToStopFiringBeam(_pName:StringName) -> void:
	animationPlayerEyes.current_animation_changed.disconnect(WaitToStopFiringBeam)
	StopFiringBeams()


func FireKnockbackPulse() -> void:
	knockbackPulse.Fire()


func Scream() -> void:
	animationPlayerMouth.play("Mouth_Close")
	animationPlayerMouth.queue("Mouth_Scream")


func InitiatePhaseChange() -> void:
	animationPlayerMouth.play("Mouth_Close")
	animationPlayerMouth.queue("Mouth_Scream_PhaseChange")


func StartChompAttack() -> void:
	GenerateChompCooldown()
	animationPlayerMouth.play("Mouth_Close")
	animationPlayerMouth.queue("Attack_Chomp_Open")
	#animationPlayerMouth.queue("Attack_Chomp_Active")
	#animationPlayerMouth.queue("Attack_Chomp_End")


func MouthNotInUse() -> bool:
	match animationPlayerMouth.current_animation:
		"Mouth_Scream_PhaseChange", "Mouth_Scream":
			return false
		"Attack_Chomp_Open", "Attack_Chomp_Active", "Attack_Chomp_End":
			return false
	return true


func IsBeamActive() -> bool:
	match animationPlayerEyes.current_animation:
		"BeamChargeFire", "BeamFiring", "BeamStopFiring":
			return true
	return false


func BigActionActive() -> bool:
	if(!MouthNotInUse()):
		return true
	if(IsBeamActive()):
		return true
	match animationPlayerEyes.current_animation:
		"OpenEyes":
			return true
	return false


func IsChompAttackActive() -> bool:
	return animationPlayerMouth.current_animation == "Attack_Chomp_Active"


func IsChompAttackEnding() -> bool:
	return animationPlayerMouth.current_animation == "Attack_Chomp_End"


func FireFrontEyeBlasters(pRoundsInBurst:int = 1) -> void:
	eyeBlasterFrontLeft.StartCharging(pRoundsInBurst)
	eyeBlasterFrontRight.StartCharging(pRoundsInBurst)
	GenerateFrontEyeBlasterCooldown()


func FireBackEyeBlasters(pRoundsInBurst:int = 1) -> void:
	eyeBlasterBackLeft.StartCharging(pRoundsInBurst)
	eyeBlasterBackRight.StartCharging(pRoundsInBurst)
	if(boss.isInPhaseTwo):
		eyeBlasterBackCenter.StartCharging(pRoundsInBurst)
	GenerateBackEyeBlasterCooldown()


func PhaseTwoChompBackEyeBlasters() -> void:
	if(boss.isInPhaseTwo):
		FireBackEyeBlasters()


func HandleDebugInputs() -> void:
	if(!debugEnabled):
		return
	if(Input.is_key_pressed(KEY_SPACE) && !keySpaceDown):
		print("Space: Disable Me")
		ChargeFireBeams()
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
		StopFiringBeams()
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
	if(Input.is_key_pressed(KEY_F) && !keyFDown):
		print("F: Disable Me")
		FireFrontEyeBlasters()
		keyFDown = true
	elif(!Input.is_key_pressed(KEY_F)):
		keyFDown = false
	if(Input.is_key_pressed(KEY_B) && !keyBDown):
		print("F: Disable Me")
		FireBackEyeBlasters(3)
		keyBDown = true
	elif(!Input.is_key_pressed(KEY_B)):
		keyBDown = false
