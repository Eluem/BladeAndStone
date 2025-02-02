class_name PlayerStateMachine
extends AnimationTree

signal buffered_look(pDir:Vector2)

@export var tapped:bool
@export var held:bool
@export var dragging:bool
@export var dragged:bool
@export var quickLooked:bool
@export var quickLookDir:Vector2
@export var dragLooked:bool
@export var dragLookDir:Vector2
@export var blockTurning:bool = false

@onready var animationPlayer:AnimationPlayer = $"../AnimationPlayer"
@onready var inputHandler:CharacterInputHandler = $InputHandler

var playbackRoot:AnimationNodeStateMachinePlayback = get("parameters/playback")

var tappedMaxBufferTime:float = 0.45
var tappedBufferTime:float = 0
var draggedMaxBufferTime:float = 0.45
var draggedBufferTime:float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inputHandler.press_release.connect(press_release)
	inputHandler.drag_release.connect(drag_release)
	inputHandler.held_triggered.connect(held_triggered)
	inputHandler.drag_triggered.connect(drag_triggered)
	inputHandler.drag_cancelled.connect(drag_cancelled)
	inputHandler.quick_look.connect(quick_look_triggered)
	inputHandler.drag_look.connect(drag_look_triggered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	HandleBufferTimers(delta)
	pass


func HandleBufferTimers(delta:float) -> void:
	if(tapped):
		tappedBufferTime += delta
		if(tappedBufferTime > tappedMaxBufferTime):
			print("buffer missed")
			tapped = false
			tappedBufferTime = 0
			quickLooked = false
	if(dragged):
		draggedBufferTime += delta
		if(draggedBufferTime > draggedMaxBufferTime):
			dragged = false
			draggedBufferTime = 0


func JumpToIdle() -> void:
	animationPlayer.play("RESET")
	playbackRoot.start("Idle")


func press_release() -> void:
	tapped = true
	held = false


func drag_release(_pPowerMod:float, _pDir:Vector2) -> void:
	dragged = true
	dragging = false
	held = false


func drag_triggered() -> void:
	dragging = true


func drag_cancelled() -> void:
	dragging = false


func held_triggered() -> void:
	held = true


func quick_look_triggered(pDir:Vector2) -> void:
	quickLooked = true
	quickLookDir = pDir


func drag_look_triggered(pDir:Vector2) -> void:
	dragLooked = true
	dragLookDir = pDir


func consume_tapped() -> bool:
	if(tapped):
		tapped = false
		tappedBufferTime = 0
		return true
	return false


func consume_dragged() -> bool:
	if(dragged):
		dragged = false
		draggedBufferTime = 0
		return true
	return false


func consume_buffered_look() -> void:
	if(quickLooked):
		buffered_look.emit(quickLookDir)
	elif(dragLooked):
		buffered_look.emit(dragLookDir)
	quickLooked = false
	dragLooked = false


func consume_tapped_atEnd() -> bool:
	if(is_animation_finished()):
		return consume_tapped()
	return false


func consume_held() -> bool:
	print("consume_held")
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
	tapped = false
	tappedBufferTime = 0
	dragged = false
	draggedBufferTime = 0
	held = false
	dragging = false
	quickLooked = false
	return true
