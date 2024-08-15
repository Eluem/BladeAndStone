class_name Golem
extends RigidBodyHittable
var targetRotation:float
signal exploded(pMainChunk:RigidBody2D)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	$AnimationTree/InputHandler.connect("drag_release", flick)
	$AnimationTree/InputHandler.connect("drag_update", drag_update)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	
func _physics_process(_delta: float) -> void:
	#if(Input.is_key_pressed(KEY_SPACE)):
		##apply_central_impulse(Vector2(0, 10))
		##apply_central_force(global_transform.x * 10)
		##apply_central_force(global_transform.basis_xform(Vector2.DOWN)*5000)
		#apply_central_force(global_transform.x * 5000)
	#
	#if(Input.is_key_pressed(KEY_LEFT)):
		#apply_torque(-10)
		#
	#if(Input.is_key_pressed(KEY_RIGHT)):
		#apply_torque(10)
	pass
		
func flick(powerMod:float, dir:Vector2) -> void:
	if(!isTurningAllowed()):
		return
	#apply_central_force(50000 * powerMod * dir)
	apply_central_impulse(1500 * powerMod * dir)
	targetRotation = dir.angle()

func drag_update(_powerMod:float, dir:Vector2) -> void:
	if(!isTurningAllowed()):
		return
	targetRotation = dir.angle()

	
func slash() -> void:
	#Add slight lunge
	apply_central_impulse(500 * transform.x)

func lunge(pForce:float) -> void:
	apply_central_impulse(pForce * transform.x)
	
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	#if(resetRequested):
	#	targetRotation = initialTransform.get_rotation()
		
	var xform:Transform2D = state.get_transform()
	xform.x = Vector2(1, 0)
	xform.y = Vector2(0, 1)
	xform = xform.rotated_local(targetRotation)
	#xform = xform.rotated_local(targetRotation - xform.get_rotation())
	state.set_transform(xform)
	
	#super._integrate_forces(state)

func Die(pDir:Vector2, pForce:float) -> void:
	var chunks:Array[RigidBody2D] = Geometry2DHelper.ExplodeSprite(mainSprite, pDir, Vector2(pForce*0.5, pForce), Vector2(-pForce/40, pForce/40))
	exploded.emit(chunks[0])
	queue_free()

func GetMainSprite() -> Sprite2D:
	return $MaskSpriteContainer/MaskSprite

func isTurningAllowed() -> bool:
	return !($Weapon/RaycastCollider as RaycastCollider).enabled
