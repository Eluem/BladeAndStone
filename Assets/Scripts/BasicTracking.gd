extends Camera2D
class_name TrackingCamera

enum TrackingMode {process, physics_process, interpolated}

@export var trackTarget:Node2D
@export var trackingMode:TrackingMode = TrackingMode.interpolated

var prevTransform:Transform2D
var currTransform:Transform2D
var prevPhysicsFrame:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	prevTransform = Transform2D(transform)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	if(trackTarget == null):
		return
	
	if(trackingMode == TrackingMode.process):
		UpdateTracking(delta)
	elif(trackingMode == TrackingMode.interpolated):
		UpdateTracking_Interpolated(delta)

func _physics_process(delta:float) -> void:
	if(trackTarget == null):
		return
	
	if(trackingMode == TrackingMode.interpolated):
		prevTransform = currTransform
		currTransform = Transform2D(trackTarget.transform)
	
	if(trackingMode == TrackingMode.physics_process):
		UpdateTracking(delta)

func UpdateTracking(_delta:float) -> void:
	transform.origin = trackTarget.transform.origin

func UpdateTracking_Interpolated(_delta:float) -> void:
	#transform.origin = prevTransform.interpolate_with(trackTarget.transform, Engine.get_physics_interpolation_fraction()).origin
	#transform.origin = lerp(prevTransform.origin, currTransform.origin, Engine.get_physics_interpolation_fraction())
	transform.origin = prevTransform.interpolate_with(currTransform, Engine.get_physics_interpolation_fraction()).origin
	var currPhysicsFrame:int = Engine.get_physics_frames()
	print(str(prevPhysicsFrame) + " ||| " + str(currPhysicsFrame) + " ||| " + str(Engine.get_physics_interpolation_fraction()) + " ||| " + str(prevTransform.origin) + " ||| " + str(transform.origin) + " ||| " + str(trackTarget.transform.origin))
	

#Need to figure out how to makie this work correctly and actually interpolate
#this just lags behind and freezes on duplicated physics frames
func UpdateTracking_Interpolated_WorkAround(_delta:float) -> void:
	var currPhysicsFrame:int = Engine.get_physics_frames()
	if(prevPhysicsFrame == currPhysicsFrame):
		return
	
	transform.origin = prevTransform.interpolate_with(trackTarget.transform, Engine.get_physics_interpolation_fraction()).origin
	
	prevTransform = Transform2D(trackTarget.transform)
	prevPhysicsFrame = currPhysicsFrame

#Need to figure out why this doesn't work correctly
#func UpdateTracking_Interpolated_TryingToForceProperInterpolation(_delta:float) -> void:
	#var currPhysicsFrame:int = Engine.get_physics_frames()
	##if(prevPhysicsFrame == currPhysicsFrame):
		##return
	#
	#if(currTransform.origin != trackTarget.transform.origin):
		#prevTransform = currTransform
	#
	#transform.origin = prevTransform.interpolate_with(trackTarget.transform, Engine.get_physics_interpolation_fraction()).origin
	#
	#print(str(prevPhysicsFrame) + " ||| " + str(currPhysicsFrame) + " ||| " + str(Engine.get_physics_interpolation_fraction()) + " ||| " + str(prevTransform.origin) + " ||| " + str(transform.origin) + " ||| " + str(trackTarget.transform.origin))
	#
	#currTransform = Transform2D(trackTarget.transform)
	#prevPhysicsFrame = currPhysicsFrame

func SetTrackTarget(pTrackTarget:Node2D) -> void:
	trackTarget = pTrackTarget
	if(trackTarget is Golem):
		(trackTarget as Golem).exploded.connect(SetTrackTarget)
	#prevTransform = Transform2D(trackTarget.transform)
