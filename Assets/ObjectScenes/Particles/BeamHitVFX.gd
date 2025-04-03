extends Polygon2D
class_name BeamHitVFX

var duration:float = 0.2
var timeRemaining:float = duration

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	timeRemaining -= delta
	if(timeRemaining <= 0):
		timeRemaining = 0
		#queue_free()
	color.a = timeRemaining/duration


func Update(pNewPos:Vector2, pNewDir:Vector2) -> void:
	timeRemaining = duration;
	global_position = pNewPos;
	global_rotation = pNewDir.angle()


static func Spawn(pOriginator:Node2D, pPostion:Vector2, pDirection:Vector2) -> BeamHitVFX:
	var ret:BeamHitVFX
	var scene:PackedScene = preload("res://Assets/ObjectScenes/Particles/BeamHitVFX.tscn")
	ret = scene.instantiate()
	ret.global_position = pPostion
	ret.global_rotation = pDirection.angle()
	pOriginator.get_tree().current_scene.add_child(ret)
	return ret
