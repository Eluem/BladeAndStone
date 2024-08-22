extends Area2D
@export var healValue:int = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", body_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func body_entered(pBody:Node2D) -> void:
	if(pBody is not Golem):
		return
	
	var player:Golem = pBody
	player.ApplyHeal(healValue)
	
	queue_free()
