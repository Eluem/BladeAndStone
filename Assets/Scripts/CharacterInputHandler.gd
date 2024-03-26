class_name CharacterInputHandler
extends Node2D

@export var debugEnabled:bool = true
var pressed:bool = false
var justPressed:bool = false
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
var inputDebugUI:InputDebugUI

signal drag_release(dragPower:float, dragDir:Vector2)
signal press_release(holdTime:float)

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
	
	#Update drag direction and power	
	if(pressed):
		dir = startPos - currPos
		power = (clamp(dir.length(), 0, maxLength)/maxLength)
		holdTime += delta
	
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
	
	if(debugEnabled):
		UpdateDebugUI()
	"""
	#Redraw when drag position changes
	if(debugEnabled && ((pressing && prevPos != currPos) || released)):
		queue_redraw()
	"""

func is_dragging() -> bool:
	return pressing && (startPos - currPos).length_squared() > dragThreshold

func UpdateDebugUI() -> void:
	if(justPressed):
		inputDebugUI = InputDebugUI.new()
		inputDebugUI.update(pressed, pressing, holdTime, released, startPos, currPos, prevPos, dir, power)
		get_parent().get_parent().add_child(inputDebugUI)
		inputDebugUI.position = Vector2.ZERO
	elif(inputDebugUI != null):
		inputDebugUI.update(pressed, pressing, holdTime, released, startPos, currPos, prevPos, dir, power)
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
