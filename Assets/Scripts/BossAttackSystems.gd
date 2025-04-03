extends Node2D
@onready var animationPlayerEyes:AnimationPlayer = $"../AnimationPlayerEyes"
@onready var animationPlayerMouth:AnimationPlayer = $"../AnimationPlayerMouth"
@onready var eyeLaserLeft:BossEnemy_EyeLaserProjector = $BossEnemy_EyeLaser_Left
@onready var eyeLaserRight:BossEnemy_EyeLaserProjector = $BossEnemy_EyeLaser_Right
@onready var eyeBeamFiringSFXPlayer:AudioTrack2D = $"../EyeBeamFiringSFXPlayer"
@onready var knockbackPulse:KnockbackPulse = $KnockbackPulse


#Debug button down trackers
var keySpaceDown:bool
var keyODown:bool
var keySDown:bool
var keyMDown:bool


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


func PhaseChangeTester() -> void:
	animationPlayerMouth.play("Mouth_Scream_PhaseChange")


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
		PhaseChangeTester()
		keyMDown = true
	elif(!Input.is_key_pressed(KEY_M)):
		keyMDown = false
