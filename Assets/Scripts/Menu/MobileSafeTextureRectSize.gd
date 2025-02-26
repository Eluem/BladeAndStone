extends TextureRect

func _ready() -> void:
	if(OS.has_feature("android")):
		UpdateSize()

func UpdateSize() -> void:
	size *= 2
