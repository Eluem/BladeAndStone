extends Area2D
var key:BossKey
var keyHolder:Golem
var oldFreq:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_key_holder_entered)
	body_exited.connect(_key_holder_exited)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _key_holder_entered(pBody:Node2D) -> void:
	if(pBody is not Golem):
		return
	var castBody:Golem = pBody
	if(!castBody.hasKey()):
		return
	keyHolder = castBody
	key = keyHolder.bossKey
	key.PIDControllerJoint.ignoreTrackNode = true
	oldFreq = key.PIDControllerJoint.frequency
	key.PIDControllerJoint.frequency = 2
	key.PIDControllerJoint.targetPos = global_position
	key.PIDControllerJoint.disableInDist = false

func _key_holder_exited(pBody:Node2D) -> void:
	if(pBody is not Golem):
		return
	var castBody:Golem = pBody
	if(!castBody.hasKey()):
		return
	key.PIDControllerJoint.ignoreTrackNode = false
	key.PIDControllerJoint.disableInDist = true
	key.PIDControllerJoint.frequency = oldFreq
	key = null
	keyHolder = null
