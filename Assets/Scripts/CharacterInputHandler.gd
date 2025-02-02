class_name CharacterInputHandler
extends Node2D

@export var debugEnabled:bool = false
@export var enabled:bool = true

@onready var parentPlayer:Node2D = get_parent().get_parent()

var pressed:bool = false
var justPressed:bool = false
var pressing:bool = false
var holdTime:float
var released:bool = false
var startPos:Vector2
var currPos:Vector2 #May be inverted
var prevPos:Vector2
var prevDragging:bool #Used to determine if dragging cancelled or started
var dir:Vector2
var power:float
var maxLength:float = 400 #The max length that you can drag, anything more is ignored
var dirUpdateThreshold:float = 10 #The max length you can drag before direction info starts updating
var dragThreshold:float = 120 #The max length that you can drag that will count as a tap
							  #before converting to a drag, updating the look direction and
							  #stops counting as a quick look
var heldThreshold:float = 0.2 #Time before "held" trigger fires, if not dragging
var quickLookTime:float = heldThreshold #Time before you automatically quickLook before releasing
var dragHeldThresholdBonus:float = 0.15 #Additional time before "held" trigger fires, if dragging
var heldFired:bool = false #Prevent echoing held
var characterInputUI:CharacterInputUI
var inputDebugUI:InputDebugUI
var startedPressOnPause:bool

signal drag_release(pDragPower:float, pDragDir:Vector2)
signal press_release(pHoldTime:float)
signal quick_look(pDir:Vector2) #Used for quick look kludge to look in the direction you tap for quick attacks
signal drag_look(pDir:Vector2) #Used for drag look buffering kludge
signal held_triggered()
signal drag_triggered()
signal drag_cancelled()
signal drag_update(pDragPower:float, pDragDir:Vector2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#top_level = true
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	if(!enabled):
		return
	
	#Update important values every frame
	released = false
	justPressed = false
	currPos = get_viewport().get_mouse_position()
	pressed = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	
	#Handle blocking the player input if they're clicking on the pause button
	if(!pressing && pressed && HoveringPause()):
		startedPressOnPause = true
		return
	if(startedPressOnPause):
		if(!pressed):
			startedPressOnPause = false
		else:
			return
	
	#Press initialization
	if(pressed && !pressing):
		justPressed = true
		pressing = true
		startPos = currPos
		holdTime = 0
	
	#Handle inversion
	if(GameStateManager.gameData.invertInputDirection):
		currPos = startPos - (currPos - startPos)
	dir = startPos - currPos #Update direction/length of drag
	#Check if the drag length is in the deadzone
	var isBelowDirUpdateThreshold:bool = (dir.length_squared() <= dirUpdateThreshold**2)
	
	#Manage drag state/launch flick on drag release
	if(!pressed && pressing):
		if(is_dragging()):
			drag_release.emit(power, dir.normalized())
		else:
			press_release.emit()
			if(isBelowDirUpdateThreshold):
				quick_look.emit(get_global_mouse_position() - parentPlayer.global_position)
			else:
				drag_look.emit(dir.normalized())
		released = true
		pressing = false

	#Update drag direction and power
	if(pressed):
		if(GameStateManager.gameData.invertInputDirection):
			currPos = startPos - (currPos - startPos)
		#dir = startPos - currPos
		isBelowDirUpdateThreshold = (dir.length_squared() <= dirUpdateThreshold**2)
		power = (clamp(dir.length(), 0, maxLength)/maxLength)
		holdTime += delta
		if(!(isBelowDirUpdateThreshold)):
			drag_update.emit(power, dir.normalized())
		if(is_dragging()):
			if(!prevDragging):
				drag_triggered.emit()
				prevDragging = true
		elif(prevDragging):
			drag_cancelled.emit()
			prevDragging = false
	else:
		holdTime = 0
		heldFired = false

	if(holdTime >= heldThreshold + GetDragHeldThresholdBonus() && !heldFired):
		held_triggered.emit()
		heldFired = true
	
	if(holdTime >= quickLookTime && isBelowDirUpdateThreshold):
		quick_look.emit(get_global_mouse_position() - parentPlayer.global_position)
	
	UpdateCharacterInputUI()
	
	if(debugEnabled):
		UpdateDebugUI()
	"""
	#Redraw when drag position changes
	if(debugEnabled && ((pressing && prevPos != currPos) || released)):
		queue_redraw()
	"""


func is_dragging() -> bool:
	return pressing && (startPos - currPos).length_squared() > dragThreshold**2
	#return pressing && (startPos - currPos).length() > dragThreshold
	

func GetDragHeldThresholdBonus() -> float:
	if(is_dragging()):
		return dragHeldThresholdBonus
	return 0


func UpdateCharacterInputUI() -> void:
	if(justPressed):
		characterInputUI = CharacterInputUI.new()
		characterInputUI.update(pressed, pressing, holdTime, released, startPos, currPos, prevPos, dir, power, maxLength, dragThreshold, dirUpdateThreshold)
		parentPlayer.add_child(characterInputUI)
		characterInputUI.position = Vector2.ZERO
	elif(characterInputUI != null):
		characterInputUI.update(pressed, pressing, holdTime, released, startPos, currPos, prevPos, dir, power, maxLength, dragThreshold, dirUpdateThreshold)
	if(released):
		characterInputUI.Detach()
		characterInputUI.global_transform = parentPlayer.global_transform
		characterInputUI = null


func UpdateDebugUI() -> void:
	if(justPressed):
		inputDebugUI = InputDebugUI.new()
		inputDebugUI.update(pressed, pressing, holdTime, released, startPos, currPos, prevPos, dir, power, maxLength, dragThreshold)
		get_parent().get_parent().add_child(inputDebugUI)
		inputDebugUI.position = Vector2.ZERO
	elif(inputDebugUI != null):
		inputDebugUI.update(pressed, pressing, holdTime, released, startPos, currPos, prevPos, dir, power, maxLength, dragThreshold)
	if(released):
		inputDebugUI.top_level = true
		inputDebugUI.global_transform = (get_parent().get_parent() as Node2D).global_transform
		inputDebugUI = null


func Disable() -> void:
	if(is_dragging()):
		drag_release.emit(0, dir.normalized())
	else:
		press_release.emit()
	enabled = false
	pressed = false
	justPressed = false
	pressing = false
	holdTime = 0
	released = false
	startPos = Vector2.ZERO
	currPos = Vector2.ZERO
	prevPos = Vector2.ZERO
	prevDragging = false
	dir = Vector2.ZERO
	power = 0
	if(characterInputUI):
		characterInputUI.queue_free()


func Enable() -> void:
	enabled = true


func HoveringPause() -> bool:
	return (CanvasManagerScene as CanvasManager).pauseButton.is_hovered()

"""
func _draw() -> void:
	if(!debugEnabled):
		return
	#draw_line(Vector2(0,0), Vector2(100,100), Color.GREEN)
	if(pressing && is_dragging()):
		#Calculate end point with length capped at max power
		var endPoint:Vector2 = get_viewport().get_mouse_position() - startPos #get_viewport().get_mouse_position() - startPoint
		endPoint = startPos + (endPoint.normalized() * clamp(endPoint.length(), 0, maxLength))
		#endPoint = get_viewport().get_mouse_position()
		
		#Calculate color based on power
		var col:Color
		col = Color.GREEN.lerp(Color.RED, power)
		
		draw_line(startPos, endPoint, col, 4, true)
	if(released):
		var col:Color
		col = Color.GREEN.lerp(Color.RED, holdTime)
		draw_circle(get_viewport().get_mouse_position(), 10, col)
"""
