extends CollisionShape2D
class_name BulletWithCCD
var shapeCast:ShapeCast2D
var prevPos:Vector2
var excludeCollisionRIDs:Array[RID] #Rids to always ignore
var hitRIDs:Array[RID] #RIDs to ignore because they were already hit this attack

signal on_hit(pHitResult:Dictionary)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shapeCast = ShapeCast2D.new()
	shapeCast.shape = shape
	add_child(shapeCast)
		
	prevPos = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func AddExceptionRID(pRID:RID) -> void:
	excludeCollisionRIDs.append(pRID)
	shapeCast.add_exception_rid(pRID)

func _physics_process(_delta: float) -> void:
	#shapeCast.force_shapecast_update()
	shapeCast.target_position = global_position - prevPos
	
	var ridCasted:RID
	var hitResult:Dictionary
	for i in range(0, shapeCast.collision_result.size()):
		hitResult = shapeCast.collision_result[i]
		hitResult["position"] = shapeCast.get_collision_point(i)
		ridCasted = hitResult.rid
		shapeCast.add_exception_rid(ridCasted)
		#shapeCast.add_exception_rid(hitData.rid as RID)
		on_hit.emit(hitResult)
	
	prevPos = global_position
