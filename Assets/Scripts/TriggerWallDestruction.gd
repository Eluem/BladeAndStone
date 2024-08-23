extends Node2D
@export var trackedWall:RigidBodyHittable
@export var deathDir:Vector2
@export var deathForce:float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	trackedWall.connect("health_changed", on_tracked_hit)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_tracked_hit(pMaxHealth:int, pHealth:int) -> void:
	if(pHealth <= 0):
		var castParent:RigidBodyHittable = get_parent()
		castParent.Die(deathDir, deathForce)
