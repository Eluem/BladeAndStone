#Slowly rotates the the sprite it's attached to
#Useful to effectively animate a basic power up/pick up without actually animating it
extends Sprite2D
@export var rotationSpeed:float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation += rotationSpeed * delta
	pass
