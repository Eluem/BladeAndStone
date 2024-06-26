extends RigidBodyHittable

var target:Node2D
var force:float = 500
var maxSpeed:float = 50 #TODO: Implement max speed
var maxFollowDist:float = 500**2
var minFollowDist:float = 300**2
var eyeBoltChargeTimer:float = 0
var eyeBoltChargeWaitTime:float = 2
var searchTimer:float = 0
var searchWaitTime:float = 0.5
var visionSensor:Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	
	
	#TODO: Make this dynamic.. ideally not in ready, make it when the player gets close enough
	#to detect
	#target = (get_node("../Golem") as Node2D)
	visionSensor = $VisionSensor
	visionSensor.connect("object_detected", object_detected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(target == null):
		visionSensor.monitoring = true
		can_sleep = true
	else:
		can_sleep = false
		visionSensor.monitoring = false
		ChargeEyeBolt(delta)

func _physics_process(_delta: float) -> void:
	if(target == null):
		return
	var dist:float = (target.global_position - global_position).length_squared()
	if(dist > maxFollowDist):
		apply_central_force(force * (target.global_position - global_position).normalized())
	elif(dist < minFollowDist):
		apply_central_force(force * (global_position - target.global_position).normalized())

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if(target == null):
		return
	var newTransform:Transform2D = state.transform
	state.transform = newTransform.looking_at(target.global_position)

func ChargeEyeBolt(delta:float) -> void:
	eyeBoltChargeTimer += delta
	if(eyeBoltChargeTimer >= eyeBoltChargeWaitTime):
		FireEyeBolt()
		eyeBoltChargeTimer = 0

func FireEyeBolt() -> void:
	var eyeBolt:EyeBolt = EyeBolt.Spawn(get_node("/root"), position, transform.x)
	eyeBolt.AddCollisionException(get_rid())

func object_detected(pBody:Node2D) -> void:
	target = pBody

func HandleHit(pHitData:HitData) -> void:
	super.HandleHit(pHitData)
	eyeBoltChargeTimer = 0
