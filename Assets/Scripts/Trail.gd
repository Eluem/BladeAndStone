extends Line2D
class_name Trail

enum AlignmentDirection
{
	Forward,
	Back,
	Left,
	Right
}

@export var MAX_LENGTH:int
@export var target:Node2D
@export var targetParent:bool = true
@export var maxRemovePerFrame:int = 2
@export var forceTipAlignment:bool = true
@export var forceTipAlignmentLength:float = 10
@export var forceTipAlignmentDirection:AlignmentDirection
@export var debugMode:bool = false
var forcedPoint:bool
var queue:Array[Vector2]

func _ready() -> void:
	top_level = true
	if(targetParent):
		target = get_parent()
 
func _process(_delta:float) -> void:
	#call_deferred("UpdateQueue")
	UpdateQueue()
	
	if(debugMode):
		queue_redraw()

func UpdateQueue() -> void:
	var newPoint:Vector2 = get_new_position()
	if(forceTipAlignment):
		if(forcedPoint):
			queue.remove_at(1)
		queue.push_front(get_new_forced_alignment_position())
		forcedPoint = true
	queue.push_front(newPoint)
 	
	var i:int = 0
	while(queue.size() > MAX_LENGTH && i < maxRemovePerFrame):
		queue.pop_back()
		i+=1
	if(queue.size() < 2):
		forcedPoint = false
 
	clear_points()
	for point:Vector2 in queue:
		add_point(point)

func get_new_position() -> Vector2:
	if(target == null):
		return get_global_mouse_position()
	return target.global_position

func get_new_forced_alignment_position() -> Vector2:
	if(target == null):
		return get_new_position()
	var ret:Vector2
	match forceTipAlignmentDirection:
		AlignmentDirection.Forward:
			ret = target.global_transform.x
		AlignmentDirection.Back:
			ret = -target.global_transform.x
		AlignmentDirection.Left:
			ret = -target.global_transform.y
		AlignmentDirection.Right:
			ret = target.global_transform.y
	return get_new_position() + (ret.normalized() * forceTipAlignmentLength)

func Reset() -> void:
	queue.clear()

func _draw() -> void:
	if(!debugMode):
		return
	if(queue.size() < 2):
		return
	for i in range(queue.size()-1, 0, -1):
		draw_line(queue[i], queue[i-1], Color.BLUE)
