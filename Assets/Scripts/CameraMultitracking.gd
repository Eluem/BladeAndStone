extends Camera2D
class_name CameraMultitracking

enum TrackTiming {
					 process ##Updates during _process
					,physics_process ##updates during _physics_process
					,interpolated ##Updates current and previous position data during _physics_process and interpolates between them to get the current actual position during _process
				}
enum CenterMode {
					 centroid ##Uses the weighted average of all tracked target's positons for the center
					,bounding_rect_center ##Finds the bounding box of all the tracked targets and uses its center
					,main_target ##Uses the mainTarget's position as the center
				}
enum SmoothMode {
					 lerp ##Uses a basic lerp from the current value to the target value (Only considers the min Speed Range Value) (Note: This is not actually linear as it slows when it gets closer)
					,move_toward ##Uses the Vector.move_toward function to linearly move the current value towards the target value (Only considers the min Speed Range Value)
					,move_toward_slowing ##Uses Vector.move_toward to move the current value towards the target value depending on the distance between the two, making use of the Speed Range min and max values
					,none ##Sets the current value to the target value, without any smoothing
				}

##Determins when the camera position and zoom will be updated
@export var trackTiming:TrackTiming
##Controls the method that the camera's target position is determined relative to the tracked targets
@export var centerMode:CenterMode
##Smoothing mode for camera position
@export var trackSmoothMode:SmoothMode = SmoothMode.lerp
##Range of speeds for camera position (Note: max only matters when using move_toward_slowing)
@export var trackSpeedRange:Vector2 = Vector2.ONE
##Smoothing mode for camera zoom
@export var zoomSmoothMode:SmoothMode = SmoothMode.lerp
##Range of speeds for camera zoom (Note: max only matters when using move_toward_slowing)
@export var zoomSpeedRange:Vector2 = Vector2.ONE
##Vertical and horizontal margins around targets for determining how much to zoom
@export var margin:Vector2 = Vector2(150, 150)
##min and max zoom range values
@export var zoomRange:Vector2 = Vector2(0.1, 0.7)
##Distance to the main target before a track target is ignored
@export var ignoreDistance:float:
	get:
		return ignoreDistance
	set(pValue):
		ignoreDistance = pValue
		_ignoreDistanceSquared = ignoreDistance**2

var _ignoreDistanceSquared:float = ignoreDistance**2
##Ratio of the total weight of all other targets to be added to the main target's weight
@export var weightSumBoostFactor:float

var targets:Dictionary = {}
var mainTarget:Node2D

var prevPos:Vector2
var currPos:Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	prevPos = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	if(targets.size() == 0):
		return
	
	if(trackTiming == TrackTiming.process):
		UpdateTracking(delta)
		UpdateZoom(delta)
	elif(trackTiming == TrackTiming.interpolated):
		UpdateTracking_Interpolated(delta)
		UpdateZoom(delta)


func _physics_process(delta:float) -> void:
	if(Engine.is_editor_hint()):
		return
	if(targets.size() == 0):
		return
	
	if(trackTiming == TrackTiming.interpolated):
		prevPos = currPos
		currPos = GetTargetsCenter()
	
	if(trackTiming == TrackTiming.physics_process):
		UpdateTracking(delta)
		UpdateZoom(delta)


func UpdateTracking(pDelta:float) -> void:
	var targetPos:Vector2
	targetPos = GetTargetsCenter()
	
	match trackSmoothMode:
		SmoothMode.lerp:
			global_position = lerp(global_position, targetPos, pDelta * trackSpeedRange.x)
		SmoothMode.move_toward:
			global_position = global_position.move_toward(targetPos, pDelta * trackSpeedRange.x)
		SmoothMode.move_toward_slowing:
			var speed:float = lerpf(trackSpeedRange.x, trackSpeedRange.y, global_position.distance_squared_to(targetPos)/(1000**2))
			speed = clampf(speed, trackSpeedRange.x, trackSpeedRange.y)
			global_position = global_position.move_toward(targetPos, pDelta * speed)
		SmoothMode.none:
			global_position = targetPos


func UpdateTracking_Interpolated(pDelta:float) -> void:
	var targetPos:Vector2
	targetPos = lerp(prevPos, currPos, Engine.get_physics_interpolation_fraction())
	
	match trackSmoothMode:
		SmoothMode.lerp:
			global_position = lerp(global_position, targetPos, pDelta * trackSpeedRange.x)
		SmoothMode.move_toward:
			global_position = global_position.move_toward(targetPos, pDelta * trackSpeedRange.x)
		SmoothMode.none:
			global_position = targetPos


func UpdateZoom(pDelta:float) -> void:
	var screenSize:Vector2 = get_viewport_rect().size
	var rect:Rect2 = Rect2(global_position, Vector2.ZERO)
	rect = rect.grow_individual(0.5, 0.5, 0.5, 0.5)
	
	for target:Node2D in targets.keys():
		if(TooFarFromMainTarget(target)):
			continue
		rect = rect.expand(target.global_position)
		rect = rect.expand(2*global_position-target.global_position)
		rect = rect.grow_individual(margin.x, margin.y, margin.x, margin.y)
	
	var z:float
	if(rect.size.x > rect.size.y * screenSize.aspect()):
		z = clamp(screenSize.x / rect.size.x, zoomRange.x, zoomRange.y)
	else:
		z = clamp(screenSize.y / rect.size.y, zoomRange.x, zoomRange.y)
	
	var newZoom:Vector2 = Vector2.ONE*z
	match zoomSmoothMode:
		SmoothMode.lerp:
			zoom = lerp(zoom, newZoom, pDelta * zoomSpeedRange.x)
		SmoothMode.move_toward:
			zoom = zoom.move_toward(newZoom, pDelta * zoomSpeedRange.x)
		SmoothMode.move_toward_slowing:
			var speed:float = lerpf(zoomSpeedRange.x, zoomSpeedRange.y, absf(z-zoom.x)/z)
			speed = clampf(speed, zoomSpeedRange.x, zoomSpeedRange.y)
			zoom = zoom.move_toward(newZoom, pDelta * speed)
		SmoothMode.none:
			zoom = newZoom


func GetTargetsCentroid() -> Vector2:
	var ret:Vector2 = Vector2.ZERO
	var weightSum:float = 0
	var weight:float
	for target:Node2D in targets.keys():
		if(target == mainTarget || TooFarFromMainTarget(target)):
			continue
		weight = targets[target]
		ret += target.global_position * weight
		weightSum += weight
	if(mainTarget):
		var weightBoost:float = weightSum*weightSumBoostFactor
		weight = targets[mainTarget]
		ret += mainTarget.global_position * (weight + weightBoost)
		weightSum += weight + weightBoost

	ret = ret/weightSum
	return ret


func GetTargetsBoundingRectCenter() -> Vector2:
	if(targets.is_empty()):
		return global_position
	var targetsArray:Array = targets.keys()
	var node2DCast:Node2D
	var boundingRect:Rect2
	if(mainTarget):
		boundingRect = Rect2(mainTarget.global_position, Vector2.ZERO)
		targetsArray.remove_at(targetsArray.find(mainTarget))
	else:
		node2DCast = targetsArray[0]
		boundingRect = Rect2(node2DCast.global_position, Vector2.ZERO)
		targetsArray.remove_at(0)
	for i:int in range(targetsArray.size()):
		node2DCast = targetsArray[i]
		if(TooFarFromMainTarget(node2DCast)):
			continue
		boundingRect = boundingRect.expand(node2DCast.global_position)
	return boundingRect.get_center()


func GetMainTargetsPosition() -> Vector2:
	if(mainTarget):
		return mainTarget.global_position
	return global_position


func GetTargetsCenter() -> Vector2:
	match centerMode:
		CenterMode.centroid:
			return GetTargetsCentroid()
		CenterMode.bounding_rect_center:
			return GetTargetsBoundingRectCenter()
		CenterMode.main_target:
			return GetMainTargetsPosition()
	
	return global_position


func AddTrackTarget(pTrackTarget:Node2D, pWeight:float) -> void:
	if(targets.has(pTrackTarget)):
		return
	targets[pTrackTarget] = pWeight
	if(pTrackTarget is RigidBodyHittable):
		(pTrackTarget as RigidBodyHittable).exploded.connect(track_target_exploded.bind(pTrackTarget))
	pTrackTarget.tree_exited.connect(track_target_deleted.bind(pTrackTarget))


func SetMainTarget(pTrackTarget:Node2D) -> void:
	if(!targets.has(pTrackTarget)):
		AddTrackTarget(pTrackTarget, 1)
	mainTarget = pTrackTarget


func RemoveTrackTarget(pTarget:Node2D) -> void:
	pTarget.tree_exited.disconnect(track_target_deleted)
	targets.erase(pTarget)


func track_target_exploded(pChunks:Array[RigidBody2D], pTrackTarget:Node2D) -> void:
	var weight:float = targets[pTrackTarget]
	AddTrackTarget(pChunks[0], weight)


func track_target_deleted(pTrackTarget:Node2D) -> void:
	RemoveTrackTarget(pTrackTarget)


func TooFarFromMainTarget(pTrackTarget:Node2D) -> bool:
	if(mainTarget == null || pTrackTarget == mainTarget):
		return false
	
	return mainTarget.global_position.distance_squared_to(pTrackTarget.global_position) > _ignoreDistanceSquared
