extends RigidBody2D
class_name BossKey

@onready var PIDControllerJoint:PIDControllerJoint2D = $PIDControllerJoint
@onready var pickupCollider:Area2D = $Area2D
@onready var chain:Line2D = $Chain
@onready var sprite:Sprite2D = $Sprites/FullKey

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PIDControllerJoint.targetPos = global_position
	pickupCollider.body_entered.connect(picked_up)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(PIDControllerJoint.trackNode):
		chain.points[0] = global_position + (global_transform.basis_xform(Vector2.RIGHT) * 20)
		chain.points[1] = PIDControllerJoint.trackNode.global_position
	else:
		sprite.rotation += delta
	pass


func picked_up(pBody:Node2D) -> void:
	if(pBody is not Golem):
		return
	var castBody:Golem = pBody
	pBody.tree_exited.connect(key_holder_destroyed)
	castBody.bossKey = self
	PIDControllerJoint.trackNode = pBody
	pickupCollider.set_deferred("monitoring", false)
	chain.visible = true
	sprite.rotation_degrees = 90


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if(PIDControllerJoint.trackNode == null):
		return
	state.transform = state.transform.looking_at(PIDControllerJoint.trackNode.global_position)

func key_holder_destroyed() -> void:
	PIDControllerJoint.trackNode = null
	pickupCollider.set_deferred("monitoring", true)
	chain.visible = false
