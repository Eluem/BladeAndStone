@tool
extends Node

@export var toggle:bool:
	get:
		return toggle
	set(value):
		toggle = value
		Toggle()

@export var enableAll:bool:
	set(value):
		EnableAll()

@export var groupA:Array[Node2D]
@export var groupB:Array[Node2D]

var tPressed:bool

func _process(_delta: float) -> void:
	if(Input.is_key_pressed(KEY_T)):
		if(!tPressed):
			tPressed = true
			toggle = !toggle
	else:
		tPressed = false


func Toggle() -> void:
	for node:Node2D in groupA:
		node.visible = toggle
	for node:Node2D in groupB:
		node.visible = !toggle


func EnableAll() -> void:
	for node:Node2D in groupA:
		node.visible = true
	for node:Node2D in groupB:
		node.visible = true
