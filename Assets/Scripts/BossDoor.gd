#@tool
extends Node2D

@onready var leftGateSegment1:Node2D = $LeftGate/BossEntranceGate
@onready var leftGateSegment2:Node2D = $LeftGate/BossEntranceGate2
@onready var leftGateSegment3:Node2D = $LeftGate/BossEntranceGate3
@onready var rightGateSegment1:Node2D = $RightGate/BossEntranceGate
@onready var rightGateSegment2:Node2D = $RightGate/BossEntranceGate2
@onready var rightGateSegment3:Node2D = $RightGate/BossEntranceGate3
@onready var leftGateCollider:CollisionPolygon2D = $LeftGate/CollisionPolygon2D
@onready var rightGateCollider:CollisionPolygon2D = $RightGate/CollisionPolygon2D

var closed:bool = true #Target position of the door (not necessarily the current position)
var closedPercent:float = 1 #How closed the gate currently is
var speed:float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


#Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#UpdateClosedPercent(delta)
	pass

func UpdateClosedPercent(pDelta: float) -> void:
	if(IsOpening()):
		closedPercent -= pDelta * speed
		closedPercent = clampf(closedPercent, 0, 1)
	elif(IsClosed()):
		closedPercent += pDelta * speed
		closedPercent = clampf(closedPercent, 0, 1)
	
	#leftGateSegment3
	rightGateSegment3.position.x = lerpf(0, 10, closedPercent)

#Checks if the gate is currently fully open
func IsOpen() -> bool:
	return !closed && closedPercent <= 0

#Checks if the gate is fully closed
func IsClosed() -> bool:
	return closed && closedPercent >= 1

#Checks if the gate is in the process of closing
func IsClosing() -> bool:
	return closed && closedPercent < 1

#Checks if the gate is in the process of opening
func IsOpening() -> bool:
	return !closed && closedPercent > 0

#Checks if the gate is currently opening or closing
func IsMoving() -> bool:
	return closedPercent > 0 && closedPercent < 1
