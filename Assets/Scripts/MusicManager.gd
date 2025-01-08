extends Node
class_name MusicManager

const MENU_MUSIC:AudioStream = preload("res://Assets/Audio/Music/Lightless Dawn.mp3")
const GAME_MUSIC:AudioStream = preload("res://Assets/Audio/Music/Kick Shock.mp3")
const BOSS_MUSIC:AudioStream = preload("res://Assets/Audio/Music/In a Heartbeat.mp3")

@onready var menuMusic:MusicTrack = $MenuMusic
@onready var gameMusic:MusicTrack = $GameMusic
