extends Node2D

@onready var polySprite:Polygon2D = $poly_sprite
@onready var outline:Line2D = $outline
var prefadeTime:float = 2.0
var maxFadeTime:float = 2.0
var fadeTime:float = maxFadeTime

func _process(delta: float) -> void:
	if(prefadeTime > 0):
		prefadeTime -= delta
	elif(fadeTime > 0):
		fadeTime -= delta
		polySprite.color.a = lerpf(0.0, 1.0, fadeTime/maxFadeTime)
		outline.default_color.a = polySprite.color.a
	else:
		queue_free()
