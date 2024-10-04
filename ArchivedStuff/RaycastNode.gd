#This doesn't make sense, because I want to raycast from the previous position
#to the current position, not the other way around. Thus, the collisions will always
#be odd and backwards. I need to do manual raycasts
extends RayCast2D
var prevPos:Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	prevPos = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	draw_debug_line()
	prevPos = global_position
	
func _physics_process(delta:float) -> void:
	target_position = prevPos


func draw_debug_line() -> void:
	var lineColor:Color = Color.GREEN
	if(is_colliding()):
		lineColor = Color.RED
	get_tree().current_scene.add_child(DebugLine.new(prevPos, global_position, lineColor))
