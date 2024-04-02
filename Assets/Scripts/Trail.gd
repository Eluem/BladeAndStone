extends Line2D
class_name Trail

@export var MAX_LENGTH:int
@export var target:Node2D
@export var targetParent:bool = true
@export var maxRemovePerFrame:int = 2
var queue:Array

func _ready() -> void:
	top_level = true
	if(targetParent):
		target = get_parent()
 
func _process(_delta:float) -> void:
	queue.push_front(get_new_position())
 	
	var i:int = 0
	while(queue.size() > MAX_LENGTH && i < maxRemovePerFrame):
		queue.pop_back()
		i+=1
 
	clear_points()
	for point:Vector2 in queue:
		add_point(point)

func get_new_position() -> Vector2:
	if(target == null):
		return get_global_mouse_position()
	return target.global_position

func Reset() -> void:
	queue.clear()
