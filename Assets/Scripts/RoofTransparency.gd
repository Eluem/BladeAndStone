#Hides and unhides visuals when the player contacts the collider
extends Area2D
@export var opacityRange:Vector2 = Vector2(0.3, 1)
@export var transitionSpeed:float = 1

@onready var visuals:Node2D = $Visuals
var transitionDirection:int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", on_player_enter)
	connect("body_exited", on_player_exit)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	visuals.modulate.a += transitionSpeed * transitionDirection * delta
	visuals.modulate.a = clampf(visuals.modulate.a, opacityRange.x, opacityRange.y)	
	pass

func on_player_enter(pBody:Node2D) -> void:
	if(pBody is Golem):
		transitionDirection = -1

func on_player_exit(pBody:Node2D) -> void:
	if(pBody is Golem):
		transitionDirection = 1
