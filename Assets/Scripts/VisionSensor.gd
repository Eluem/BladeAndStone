extends Area2D
class_name VisionSensor

signal object_detected(pBody:Node2D)

var ignoreLineOfSight:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	if(monitoring):
		scan_vision()
	#queue_redraw() I don't know why this was here... typo?
	
func scan_vision() -> void:
	var bodies:Array[Node2D] = get_overlapping_bodies()
	#var castHittable:RigidBodyHittable
	var spaceState:PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	for body in bodies:
		if(body is Golem):
			if(ignoreLineOfSight || RaycastHelper.CheckLineOfSight(spaceState, global_position, body)):
				object_detected.emit(body)
			#var query:PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(global_position, body.global_position)
			#var results:Array[Dictionary]
			#results = RaycastHelper.RaycastAll(get_world_2d().direct_space_state, query)
			#for result in results:
				#if(result.collider is StaticBodyHittable):
					#return
				#if(result.collider is RigidBodyHittable):
					#castHittable = result.collider #as RigidBodyHittable
					#if(castHittable.blockLineOfSight):
						#return
				#if(result.collider == body):
					#object_detected.emit(body)
					
