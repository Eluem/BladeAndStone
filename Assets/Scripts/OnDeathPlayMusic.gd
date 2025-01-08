extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent:RigidBodyHittable = get_parent()
	parent.exploded.connect(_wall_exploded)


func _wall_exploded(_pChunks:Array[RigidBody2D], _pHitOwner:Node2D) -> void:
	(MusicManagerScene as MusicManager).gameMusic.PlayTrack()
