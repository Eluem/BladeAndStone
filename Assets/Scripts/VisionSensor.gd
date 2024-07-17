extends Area2D
signal object_detected(pBody:Node2D)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(monitoring):
		scan_vision()
	queue_redraw()
	
func scan_vision() -> void:
	var bodies: Array[Node2D] = get_overlapping_bodies()
	
	for body in bodies:
		if(body is Golem):
			var query:PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(global_position, body.global_position)
			var results:Array[Dictionary]
			results = RaycastHelper.RaycastAll(get_world_2d().direct_space_state, query)
			for result in results:
				if(result.collider is StaticBodyHittable):
					return
				if(result.collider == body):
					object_detected.emit(body)
