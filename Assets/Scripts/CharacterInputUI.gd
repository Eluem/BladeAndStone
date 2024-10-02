class_name CharacterInputUI
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

var currPosRelative:Vector2
var startPosRelative:Vector2 = Vector2.ZERO

var guidePathStartColor:Color = Color(0.8, 0.1, 0.1, 0.2)
var guidePathEndColor:Color = Color(0.8, 0.1, 0.1, 0.7)
var touchCircleColor:Color = Color(0.5765, 0.4392, 0.8588, 0.8)

var viewport:Viewport

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewport = get_viewport()
	UpdateLocalPositions()

func update(pPressed:bool, pPressing:bool, pHoldTime:float, pReleased:bool, pStartPos:Vector2, pCurrPos:Vector2, pPrevPos:Vector2, pDir:Vector2, pPower:float, pMaxLength:float, pDragThreshold:float) -> void:
	pressed = pPressed
	pressing = pPressing
	holdTime = pHoldTime
	released = pReleased
	startPos = pStartPos
	currPos = pCurrPos
	prevPos = pPrevPos
	dir = pDir
	power = pPower
	maxLength = pMaxLength
	dragThreshold = pDragThreshold

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(released):
		timeToDecay -= delta
		if(timeToDecay <= 0):
			queue_free()
	else:
		UpdateLocalPositions()
		UpdateRelativePositions()
	
	queue_redraw()

func _draw() -> void:
	if(is_dragging()): #(pressing && is_dragging()) || released):
		#Calculate end point with length capped at max power
		var endPoint:Vector2 = currPosRelative - startPosRelative
		endPoint = startPosRelative + (endPoint.normalized() * clamp(endPoint.length(), 0, maxLength))
		
		Draw_GuidePath(endPoint)
	
	#Calculate touch circle fadeout alpha
	var touchCircleColorFaded:Color = touchCircleColor
	touchCircleColorFaded.a *= timeToDecay
	
	#Draw touch cirlce
	draw_arc(startPosLocal, dragThreshold, 0, 360, 360, touchCircleColorFaded, 1, true)

func is_dragging() -> bool:
	#return pressing && (startPos - currPos).length_squared() > dragThreshold*dragThreshold
	return (startPos - currPos).length_squared() > dragThreshold*dragThreshold

func ScreenPosToLocalPos(pScreenPos:Vector2) -> Vector2:
	var viewportXform:Transform2D = viewport.canvas_transform
	
	var inverseScale:Vector2 = viewportXform.get_scale()
	inverseScale.x = 1/inverseScale.x**2
	inverseScale.y = 1/inverseScale.y**2
	
	pScreenPos = pScreenPos * (viewportXform * global_transform);
	
	pScreenPos *= inverseScale
	return pScreenPos

func UpdateLocalPositions() -> void:
	currPosLocal = ScreenPosToLocalPos(currPos)
	startPosLocal = ScreenPosToLocalPos(startPos)

func UpdateRelativePositions() -> void:
	currPosRelative = currPosLocal - startPosLocal

func Draw_GuidePath(pBackEndPoint:Vector2) -> void:
	var frontEndPoint:Vector2 = pBackEndPoint * -0.4
	
	#draw points out back
	for i in range(0,5):
		Draw_GuideArrow((pBackEndPoint/4) * i, frontEndPoint.normalized(), 5, true)
		
	#draw points out front
	for i in range(1,4):
		Draw_GuideArrow((frontEndPoint/3) * i, frontEndPoint.normalized(), 5, true)

func Draw_GuideArrow(pPos:Vector2, pDir:Vector2, pWidth:float = -1, pAntialiased:bool = false) -> void:
	#var arrowLength:Vector2 =  pPos+(pDir * 20)
	var arrowEndRight:Vector2 = pPos - (pDir.rotated(-PI/4) * 50)
	var arrowEndLeft:Vector2 = pPos - (pDir.rotated(PI/4) * 50)
	
	var vectArray:PackedVector2Array = []
	vectArray.append(arrowEndLeft)
	vectArray.append(pPos)
	vectArray.append(arrowEndRight)

	draw_polyline(vectArray, CalcGuideArrowColor(), pWidth, pAntialiased)

func CalcGuideArrowColor() -> Color:
	var ret:Color
	ret = guidePathStartColor.lerp(guidePathEndColor, power)
	ret.a *= timeToDecay
	return ret
