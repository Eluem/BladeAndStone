class_name PlayerStateMachine
extends AnimationTree
var playbackRoot:AnimationNodeStateMachinePlayback = get("parameters/playback")
var inputHandler:CharacterInputHandler

@export var tapped:bool
@export var held:bool
@export var dragging:bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$InputHandler.connect("press_release", press_release)
	$InputHandler.connect("held_triggered", held_triggered)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func press_release() -> void:
	tapped = true

func held_triggered() -> void:
	held = true

func consume_tapped() -> bool:
	if(tapped):
		tapped = false
		return true
	return false

func consume_tapped_atEnd() -> bool:
	if(is_animation_finished()):
		return consume_tapped()
	return false

func consume_held() -> bool:
	if(held):
		held = false
		return true
	return false

#This doesn't seem to work reliably...???
func consume_held_atEnd() -> bool:
	if(is_animation_finished()):
		return consume_held()
	return false

#This doesn't seem to be reliable....
func is_animation_finished() -> bool:
	var currPlayback:AnimationNodeStateMachinePlayback = get_current_stateMachinePlayback()
	return currPlayback.get_current_play_position() >= currPlayback.get_current_length()

func get_current_stateMachinePlayback() -> AnimationNodeStateMachinePlayback:
	var ret:AnimationNodeStateMachinePlayback = playbackRoot
	var nodePath:String = "parameters"
	while(get(nodePath + "/" + ret.get_current_node() + "/playback") != null):
		nodePath += "/" + ret.get_current_node()
		ret = get(nodePath + "/playback")
	return ret

func clear_held() -> void:
	held = false

func clear_buffers() -> bool:
	print("clear buffers")
	tapped = false
	held = false
	dragging = false
	return true
