class_name InputDebugUI
extends Node2D
var pressed:bool = false
var pressing:bool = false
var holdTime:float
var released:bool = false
var startPos:Vector2
var currPos:Vector2
var prevPos:Vector2
var dir:Vector2
var power:float
var maxLength:float = 200 #The max length that you can drag, anything more is ignored
var dragThreshold:float = 5 #The max length that you can drag that will count as a tap
							#before converting to a drag

var timeToDecay:float = 1
var currPosLocal:Vector2 
var startPosLocal:Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UpdateLocalPositions()

func update(pPressed:bool, pPressing:bool, pHoldTime:float, pReleased:bool, pStartPos:Vector2, pCurrPos:Vector2, pPrevPos:Vector2, pDir:Vector2, pPower:float) -> void:
	pressed = pPressed
	pressing = pPressing
	holdTime = pHoldTime
	released = pReleased
	startPos = pStartPos
	currPos = pCurrPos
	prevPos = pPrevPos
	dir = pDir
	power = pPower

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(released):
		timeToDecay -= delta
		if(timeToDecay <= 0):
			queue_free()
	else:
		UpdateLocalPositions()
	
	queue_redraw()

func _draw() -> void:
	if(pressing && is_dragging() || released):
		#Calculate end point with length capped at max power
		var endPoint:Vector2 = currPosLocal - startPosLocal #get_viewport().get_mouse_position() - startPoint
		endPoint = startPosLocal + (endPoint.normalized() * clamp(endPoint.length(), 0, maxLength))
		
		#Calculate color based on power
		var lineCol: Color
		lineCol = Color.GREEN.lerp(Color.RED, power)
		lineCol.a = timeToDecay
		draw_line(startPosLocal, endPoint, lineCol, 4, true)
		
	var pointCol: Color
	pointCol = Color.GREEN.lerp(Color.RED, holdTime)
	pointCol.a = timeToDecay
	draw_circle(currPosLocal, 10, pointCol)

func is_dragging() -> bool:
	return pressing && (startPos - currPos).length_squared() > dragThreshold

func ScreenPosToLocalPos(pScreenPos:Vector2) -> Vector2:
	return pScreenPos * (get_viewport_transform() * global_transform);

func UpdateLocalPositions() -> void:
	currPosLocal = ScreenPosToLocalPos(currPos)
	startPosLocal = ScreenPosToLocalPos(startPos)
