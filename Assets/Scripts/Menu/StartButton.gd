extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(StartGame)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func StartGame() -> void:
	get_tree().change_scene_to_file("res://Assets/GameScenes/VerticalSlice.tscn")
