@tool
extends Camera2D
class_name CameraMultitracking_DictionaryList_bk09242024

enum TrackTiming {process, physics_process, interpolated}
enum CenterMode {centroid, experimental}

@export var trackTiming:TrackTiming
@export var centerMode:CenterMode
@export var margin:Vector2 = Vector2(150, 150)
@export var zoomRange:Vector2 = Vector2(1, 300)
@export var smoothTracking:bool = true
@export var trackSpeed:float = 1
@export var smoothZooming:bool = true
@export var zoomSpeed:float = 1

@export var targets:Array[Dictionary] = []:
	get:
		return targets
	set(pValue):
		print(pValue)
		print("here")
		if(pValue.size()) > 0:
			var newDict:Dictionary = pValue[pValue.size() - 1]
			if(newDict.is_empty()):
				newDict["node"] = NodePath("")
				newDict["weight"] = 1
			if(pValue[0].node is EncodedObjectAsID):
				for i in range(pValue.size()):
					if(i < targets.size()):
						targets[i].weight = pValue[i].weight
			else:
				targets = pValue
		else:
			targets = pValue

var prevPos:Vector2
var currPos:Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(Engine.is_editor_hint()):
		return
	InitializeTargets()
	print(targets)
	prevPos = global_position

func InitializeTargets() -> void:
	print("init")
	var castNodePath:NodePath
	for targetData:Dictionary in targets:
		if(targetData.node is NodePath):
			castNodePath = targetData.node
			targetData.node = get_node(castNodePath)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	if(Engine.is_editor_hint()):
		return
	
	if(Input.is_key_pressed(KEY_F)):
		var dict:Dictionary = targets[0].duplicate()
		targets[0] = dict
		#targets[0].weight += 1
		#print((targets[0].node as Node2D).get_instance_id())
		#print(instance_from_id((targets[0].node as Node2D).get_instance_id()))
	
	
	if(targets.size() == 0):
		return
	
	if(trackTiming == TrackTiming.process):
		UpdateTracking(delta)
	elif(trackTiming == TrackTiming.interpolated):
		UpdateTracking_Interpolated(delta)

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

func UpdateTracking(_delta:float) -> void:
	global_position = GetTargetsCenter()

func UpdateTracking_Interpolated(_delta:float) -> void:
	global_position = lerp(prevPos, currPos, Engine.get_physics_interpolation_fraction())


func UpdateZoom(pDelta:float) -> void:
	var screenSize:Vector2 = get_viewport_rect().size
	var rect:Rect2 = Rect2(global_position, Vector2.ONE)
	var castNode:Node2D
	for target:Dictionary in targets:
		castNode = target["Node"]
		rect = rect.expand(castNode.global_position)
		rect = rect.grow_individual(margin.x, margin.y, margin.x, margin.y)
	
	var z:float
	if(rect.size.x > rect.size.y * screenSize.aspect()):
		z = clamp(rect.size.x / screenSize.x, zoomRange.x, zoomRange.y)
	else:
		z = clamp(rect.size.y / screenSize.y, zoomRange.x, zoomRange.y)
	z = 1/z
	zoom = lerp(zoom, Vector2.ONE * z, pDelta)


func GetTargetsCentroid() -> Vector2:
	var ret:Vector2 = Vector2.ZERO
	var castNode:Node2D
	var weight:float
	var weightSum:float = 0
	for target:Dictionary in targets:
		castNode = target["node"]
		weight = target["weight"]
		ret += castNode.global_position * weight
		weightSum += weight
	ret = ret/weightSum
	return ret


func GetTargetsCenterExperimental() -> Vector2:
	return Vector2.ZERO


func GetTargetsCenter() -> Vector2:
	match centerMode:
		CenterMode.centroid:
			return GetTargetsCentroid()
		CenterMode.experimental:
			return GetTargetsCenterExperimental()
	
	return global_position


func AddTrackTarget(pTrackTarget:Node2D) -> void:
	var trackData:Dictionary
	trackData["node"] = pTrackTarget
	trackData["weight"] = 1
	targets.append(trackData)
	pTrackTarget.tree_exited.connect(track_target_deleted.bind(trackData))
	if(pTrackTarget is RigidBodyHittable):
		(pTrackTarget as RigidBodyHittable).exploded.connect(track_target_exploded)


func track_target_deleted(pTargetData:Dictionary) -> void:
	targets.remove_at(targets.find(pTargetData))


func track_target_exploded(pChunks:Array[RigidBody2D]) -> void:
	AddTrackTarget(pChunks[0])
