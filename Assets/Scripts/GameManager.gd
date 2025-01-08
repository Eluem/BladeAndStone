extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#(MusicManagerScene as MusicManager).menuMusic.PauseTrack()
	(MusicManagerScene as MusicManager).menuMusic.FadeTrackOut(1.0)
