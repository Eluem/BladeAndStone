extends Node2D
class_name PIDControllerJoint2D

@export var trackNode:Node2D
@export var trackDist:float = 0
@export var disableInDist:bool = true
@export var trackDistDisableBuffer:float = 0
@export var trackDistReenableBuffer:float = 0

@export var frequency:float = 1
@export var damping:float = 1

@export var targetPos:Vector2
@export var targetVel:Vector2

@onready var rb:RigidBody2D = get_parent()
var _PIDController:PIDController2D = PIDController2D.new()
var inDisabledDist:bool = false
var ignoreTrackNode:bool = false

func _physics_process(delta: float) -> void:
	if(is_instance_valid(trackNode) && !ignoreTrackNode):
		targetPos = trackNode.global_position
	
	if(!CheckDist()):
		return
	
	var finalTargetPos:Vector2 = targetPos
	if(!ignoreTrackNode):
		finalTargetPos += (trackDist * (targetPos.direction_to(rb.global_position)))
	
	_PIDController.targetPos = finalTargetPos
	_PIDController.targetVel = targetVel
	_PIDController.frequency = frequency
	_PIDController.damping = damping
	
	var force:Vector2 = _PIDController.Update(delta, rb.global_position, rb.linear_velocity)
	rb.apply_central_force(force)

func CheckDist() -> bool:
	if(!disableInDist):
		return true
	var currDist:float = (targetPos - rb.global_position).length()
	if(currDist <= (trackDist + trackDistDisableBuffer)):
		#if(!inDisabledDist):
			#rb.linear_velocity = Vector2.ZERO
		inDisabledDist = true
	elif(currDist > (trackDist + trackDistReenableBuffer)):
		inDisabledDist = false
	
	return !inDisabledDist
