extends AudioStreamPlayer
class_name MusicTrack

@export var defaultTrack:AudioStream

var isFadingTrackOut:bool
var isFadingTrackIn:bool
var fadeTrackTime:float
var fadeTrackDuration:float

func _process(delta: float) -> void:
	HandleFade(delta)


func HandleFade(pDelta:float) -> void:
	if(!isFadingTrackIn && !isFadingTrackOut):
		return
	if(isFadingTrackOut):
		fadeTrackTime -= pDelta
		if(fadeTrackTime <= 0):
			isFadingTrackOut = false
			fadeTrackTime = 0
			PauseTrack()
	if(isFadingTrackIn):
		fadeTrackTime += pDelta
		if(fadeTrackTime >= fadeTrackDuration):
			isFadingTrackIn = false
			fadeTrackTime = fadeTrackDuration
	volume_db = linear_to_db(fadeTrackTime / fadeTrackDuration)


func FadeTrackOut(pDuration:float) -> void:
	isFadingTrackOut = true
	fadeTrackDuration = pDuration
	if(isFadingTrackIn):
		isFadingTrackIn = false
	else:
		fadeTrackTime = pDuration


func FadeTrackIn(pDuration:float) -> void:
	isFadingTrackIn = true
	fadeTrackDuration = pDuration
	if(isFadingTrackOut):
		isFadingTrackOut = false
	else:
		fadeTrackTime = 0


func StopTrackFade() -> void:
	isFadingTrackOut = false
	isFadingTrackIn = false
	fadeTrackTime = 0
	fadeTrackDuration = 0


func PlayTrack(pTrack:AudioStream = null, pFromPosition:float = 0.0) -> void:
	if(pTrack == null):
		pTrack = defaultTrack
	stream_paused = false
	stream = pTrack
	play(pFromPosition)
	volume_db = 1.0


func PauseTrack() -> void:
	stream_paused = true


func ResumeTrack() -> void:
	stream_paused = false


func ResumeOrPlayTrack() -> void:
	stream_paused = false
	if(stream == null):
		stream = defaultTrack
	if(!playing):
		play()
		volume_db = 1.0
