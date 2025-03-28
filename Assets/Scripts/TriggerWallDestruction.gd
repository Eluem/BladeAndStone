extends Node2D
@export var trackedWall:RigidBodyHittable
@export var deathDir:Vector2
@export var deathForce:float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	trackedWall.damage_taken.connect(on_tracked_hit)


func on_tracked_hit(_pDamage:int, pHitOwner:Node2D) -> void:
	if(trackedWall.health <= 0):
		var castParent:RigidBodyHittable = get_parent()
		castParent.Die(pHitOwner, deathDir, deathForce)
