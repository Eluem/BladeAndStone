class_name Golem
extends DebugResettableRigdbody
var targetRotation:float
var targetDir:Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationTree/InputHandler.connect("drag_release", flick)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	
func _physics_process(_delta: float) -> void:
	if(Input.is_key_pressed(KEY_SPACE)):
		#apply_central_impulse(Vector2(0, 10))
		#apply_central_force(global_transform.x * 10)
		#apply_central_force(global_transform.basis_xform(Vector2.DOWN)*5000)
		apply_central_force(global_transform.x * 5000)
	
	if(Input.is_key_pressed(KEY_LEFT)):
		apply_torque(-10)
		
	if(Input.is_key_pressed(KEY_RIGHT)):
		apply_torque(10)
		
func flick(powerMod:float, dir:Vector2) -> void:
	apply_central_force(50000 * powerMod * dir)
	targetRotation = dir.angle()
	targetDir = dir
	
func slash() -> void:
	#Add slight lunge
	apply_central_force(15000 * transform.x)
	
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if(resetRequested):
		targetRotation = initialTransform.get_rotation()
		
	var xform:Transform2D = state.get_transform()
	xform.x = Vector2(1, 0)
	xform.y = Vector2(0, 1)
	xform = xform.rotated_local(targetRotation)
	#xform = xform.rotated_local(targetRotation - xform.get_rotation())
	state.set_transform(xform)
	
	super._integrate_forces(state)
	
"""
func _input(event):
	if(event.is_action_pressed("ui_accept")):
		apply_central_force(Vector2(10, 10))
"""
