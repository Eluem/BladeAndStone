extends RigidBody2D
class_name Hazard
@export var damage:int
@export var knockback:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Collider.connect("on_hit", on_hit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func on_hit(_hitData:Dictionary) -> void:
	#print("on_hit")
	#print(hitData.collider.name)
	pass
