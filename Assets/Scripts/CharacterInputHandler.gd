class_name CharacterInputHandler
extends Node2D

@export var debugEnabled:bool = false
var pressed:bool = false
var justPressed:bool = false
var pressing:bool = false
var holdTime:float
var released:bool = false
var startPos:Vector2
var currPos:Vector2
var prevPos:Vector2
var prevDragging:bool #used to determine if dragging cancelled or started
var dir:Vector2
var power:float
var maxLength:float = 400 #The max length that you can drag, anything more is ignored
var dirUpdateThreshold:float = 10 #The max length you can drag before direction info starts updating
var dragThreshold:float = 80 #The max length that you can drag that will count as a tap
							 #before converting to a drag
var heldTreshold:float = 0.2 #Time before "held" trigger fires, if not dragging
var heldFired:bool = false #Prevent echoing held
var characterInputUI:CharacterInputUI
var inputDebugUI:InputDebugUI

signal drag_release(dragPower:float, dragDir:Vector2)
signal press_release(holdTime:float)
signal held_triggered()
signal drag_triggered()
signal drag_cancelled()
signal drag_update(dragPower:float, dragDir:Vector2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#top_level = true
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	released = false
	justPressed = false
	currPos = get_viewport().get_mouse_position()
	pressed = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	
	#Manage drag state/launch flick on drag release
	if(pressed && !pressing):
		justPressed = true
		pressing = true
		startPos = currPos
		holdTime = 0
	elif(!pressed && pressing):
		if(is_dragging()):
			drag_release.emit(power, dir.normalized())
		else:
			press_release.emit()
		released = true
		pressing = false

	#Update drag direction and power	
	if(pressed):
		dir = startPos - currPos
		power = (clamp(dir.length(), 0, maxLength)/maxLength)
		holdTime += delta
		if(dir.length_squared() > dirUpdateThreshold * dirUpdateThreshold):
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

	if(holdTime >= heldTreshold && !heldFired):
		held_triggered.emit()
		heldFired = true
	
	UpdateCharacterInputUI()
	
	if(debugEnabled):
		UpdateDebugUI()
	"""
	#Redraw when drag position changes
	if(debugEnabled && ((pressing && prevPos != currPos) || released)):
		queue_redraw()
	"""

func is_dragging() -> bool:
	return pressing && (startPos - currPos).length_squared() > dragThreshold * dragThreshold

func UpdateCharacterInputUI() -> void:
	if(justPressed):
		characterInputUI = CharacterInputUI.new()
		characterInputUI.update(pressed, pressing, holdTime, released, startPos, currPos, prevPos, dir, power, maxLength, dragThreshold)
		get_parent().get_parent().add_child(characterInputUI)
		characterInputUI.position = Vector2.ZERO
	elif(characterInputUI != null):
		characterInputUI.update(pressed, pressing, holdTime, released, startPos, currPos, prevPos, dir, power, maxLength, dragThreshold)
	if(released):
		characterInputUI.top_level = true
		characterInputUI.global_transform = (get_parent().get_parent() as Node2D).global_transform
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
		#get_parent().get_parent().remove_child(inputDebugUI)
		#get_node("/root").add_child(inputDebugUI)
		inputDebugUI.top_level = true
		inputDebugUI.global_transform = (get_parent().get_parent() as Node2D).global_transform
		#print(inputDebugUI.released)
		inputDebugUI = null

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
		var col: Color
		col = Color.GREEN.lerp(Color.RED, power)
		
		draw_line(startPos, endPoint, col, 4, true)
	if(released):
		var col: Color
		col = Color.GREEN.lerp(Color.RED, holdTime)
		draw_circle(get_viewport().get_mouse_position(), 10, col)
"""
