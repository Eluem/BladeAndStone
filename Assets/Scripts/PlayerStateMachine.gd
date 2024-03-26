class_name PlayerStateMachine
extends AnimationTree

var inputHandler:CharacterInputHandler

@export var tapped:bool
@export var held:bool
@export var dragging:bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$InputHandler.connect("press_release",press_release)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func flick() -> void:
	tapped = true

func press_release() -> void:
	tapped = true

func consume_tapped() -> bool:
	if(tapped):
		tapped = false
		return true
	return false
