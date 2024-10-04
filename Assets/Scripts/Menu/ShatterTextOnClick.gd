extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(ShatterSelf)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	pass

func ShatterSelf() -> void:
	var tempSprite:Sprite2D = Sprite2D.new()
	var chunks:Array[RigidBody2D]
	tempSprite.texture = texture_normal
	add_child(tempSprite)
	chunks = Geometry2DHelper.ExplodeSprite(tempSprite, Vector2.DOWN, Vector2(100,200), Vector2(-20, 20))
	tempSprite.queue_free()
	
	for chunk in chunks:
		chunk.linear_damp = 0
		chunk.linear_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
		chunk.add_constant_central_force(Vector2.DOWN * 100)
		chunk.reparent(get_parent())
