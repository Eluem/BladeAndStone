#Simple script that pulses the alpha color of a Polygon2D
extends Polygon2D
@export var pulseRate:float = 1
@export var pulseRange:Vector2 = Vector2(0, 1)
var pulseDirection:int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	color.a += pulseRate * pulseDirection * delta
	if(color.a <= pulseRange.x || color.a >= pulseRange.y):
		pulseDirection *= -1
	pass
