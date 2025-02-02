class_name Golem
extends RigidBodyHittable
@onready var inputHandler:CharacterInputHandler = $AnimationTree/InputHandler
@onready var animationTree:PlayerStateMachine = $AnimationTree

var targetRotation:float
var bossKey:BossKey

#signal exploded(pMainChunk:RigidBody2D)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	damage_taken.connect(StatTracker.character_took_damage.bind(self))
	exploded.connect(StatTracker.character_exploded.bind(self))
	add_to_group("Player")
	inputHandler.drag_release.connect(flick)
	inputHandler.drag_update.connect(drag_update)
	inputHandler.quick_look.connect(quick_look)
	animationTree.buffered_look.connect(quick_look)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	super._process(delta)


func _physics_process(_delta:float) -> void:
	pass


func flick(pDowerMod:float, pDir:Vector2) -> void:
	if(!isTurningAllowed()):
		return
	#apply_central_force(50000 * powerMod * dir)
	#apply_central_impulse(1500 * powerMod * dir)
	apply_central_impulse(1700 * pDowerMod * pDir)
	targetRotation = pDir.angle()


func quick_look(pDir:Vector2) -> void:
	if(!isTurningAllowed()):
		return
	#var dir:Vector2 = pGlobalPos - global_position #Doesn't need normalization, more efficent than direction_to
	targetRotation = pDir.angle()


func drag_update(_pPowerMod:float, pDir:Vector2) -> void:
	if(!isTurningAllowed()):
		return
	targetRotation = pDir.angle()

	
func slash() -> void:
	#Add slight lunge
	apply_central_impulse(500 * transform.x)


func lunge(pForce:float) -> void:
	apply_central_impulse(pForce * transform.x)


func _integrate_forces(state:PhysicsDirectBodyState2D) -> void:
	#if(resetRequested):
	#	targetRotation = initialTransform.get_rotation()
		
	var xform:Transform2D = state.get_transform()
	xform.x = Vector2(1, 0)
	xform.y = Vector2(0, 1)
	xform = xform.rotated_local(targetRotation)
	#xform = xform.rotated_local(targetRotation - xform.get_rotation())
	state.set_transform(xform)
	
	#super._integrate_forces(state)


func GetMainSprite() -> Sprite2D:
	return $MaskSpriteContainer/MaskSprite


func isTurningAllowed() -> bool:
	#return !($Weapon/RaycastCollider as RaycastCollider).enabled
	return !animationTree.blockTurning


func hasKey() -> bool:
	return bossKey != null


func Die(pHitOwner:Node2D, pDir:Vector2, pForce:float) -> void:
	(MusicManagerScene as MusicManager).gameMusic.FadeTrackOut(2.0)
	super.Die(pHitOwner, pDir, pForce)
