extends RigidBodyHittable

var target:Node2D
var force:float = 500
var maxSpeed:float = 50 #TODO: Implement max speed
var maxFollowDist:float = 500**2
var minFollowDist:float = 300**2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	#TODO: Make this dynamic.. ideally not in ready, make it when the player gets close enough
	#to detect
	target = (get_node("../Golem") as Node2D)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	var dist:float = (target.global_position - global_position).length_squared()
	if(dist > maxFollowDist):
		apply_central_force(force * (target.global_position - global_position).normalized())
	elif(dist < minFollowDist):
		apply_central_force(force * (global_position - target.global_position).normalized())

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var newTransform:Transform2D = state.transform
	state.transform = newTransform.looking_at(target.global_position)
