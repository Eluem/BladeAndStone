extends Hazard
class_name Projectile

@onready var collider:BulletWithCCD = $Collider

var originatorRID:RID

func _ready() -> void:
	super._ready()
	if(originator is RigidBody2D):
		originatorRID = (originator as RigidBody2D).get_rid()

func AddCollisionException(pRID:RID) -> void:
	collider.AddExceptionRID(pRID)
