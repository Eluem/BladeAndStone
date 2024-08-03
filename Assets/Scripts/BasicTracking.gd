extends Camera2D
class_name TrackingCamera

enum TrackingMode {process, physics_process, interpolated}

@export var trackTarget:Node2D
@export var trackingMode:TrackingMode = TrackingMode.interpolated

var prevTransform:Transform2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	prevTransform = Transform2D(transform)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(trackTarget == null):
		return
	
	if(trackingMode == TrackingMode.process):
		UpdateTracking(delta)
	elif(trackingMode == TrackingMode.interpolated):
		UpdateTracking_Interpolated(delta)

func _physics_process(delta: float) -> void:
	if(trackingMode == TrackingMode.physics_process):
		UpdateTracking(delta)

func UpdateTracking(_delta: float) -> void:
	transform.origin = trackTarget.transform.origin

func UpdateTracking_Interpolated(_delta: float) -> void:
	transform.origin = prevTransform.interpolate_with(trackTarget.transform, Engine.get_physics_interpolation_fraction()).origin
	prevTransform = Transform2D(trackTarget.transform)

func SetTrackTarget(pTrackTarget:Node2D) -> void:
	trackTarget = pTrackTarget
	if(trackTarget is Golem):
		(trackTarget as Golem).exploded.connect(SetTrackTarget)
	#prevTransform = Transform2D(trackTarget.transform)
