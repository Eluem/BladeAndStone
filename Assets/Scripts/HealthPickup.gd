extends Area2D
const HEALTH_PICKUP_SFX = preload("res://Assets/Audio/SFX/HealthPickup.wav")
@export var healValue:int = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	pass


func _body_entered(pBody:Node2D) -> void:
	if(pBody is not Golem):
		return
	
	var player:Golem = pBody
	player.ApplyHeal(healValue)
	
	GameStateManager.PlaySFX(global_position, HEALTH_PICKUP_SFX, null, &"SFX", 8)
	
	queue_free()
