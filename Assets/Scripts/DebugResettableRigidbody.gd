extends RigidBody2D

class_name DebugResettableRigdbody

var initialTransform:Transform2D
var resetRequested:bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialTransform = transform


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	if(Input.is_key_pressed(KEY_R)):
		resetRequested = true

func _integrate_forces(state:PhysicsDirectBodyState2D) -> void:
	if(resetRequested):
		state.set_transform(initialTransform)
		linear_velocity = Vector2.ZERO
		angular_velocity = 0
		resetRequested = false
