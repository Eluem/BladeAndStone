extends Node2D

class_name TransformMatrixLearning

@export var text:Label

var targetAngle:float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(text == null):
		text = get_node("/root/Node2D/MatrixTesterLabel")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	UpdateLabel()
	#SetRotation()

func _input(event:InputEvent) -> void:
	if event is InputEventKey:
		var keyEvent:InputEventKey = event
		if keyEvent.pressed and !keyEvent.is_echo() and keyEvent.keycode == KEY_SPACE:
			transform[0] = Vector2(1, 0)
			transform[1] = Vector2(0, 1)
		elif keyEvent.pressed and !keyEvent.is_echo() and keyEvent.keycode == KEY_RIGHT:
			#targetAngle += 15
			ApplyRotationMatrix(deg_to_rad(15))
		elif keyEvent.pressed and !keyEvent.is_echo() and keyEvent.keycode == KEY_LEFT:
			#targetAngle -= 15
			ApplyRotationMatrix(deg_to_rad(-15))
			
func SetRotation() -> void:
	#transform = transform.rotated_local(deg_to_rad(targetAngle) - transform.get_rotation())
	transform.x = Vector2(cos(deg_to_rad(targetAngle)), sin(deg_to_rad(targetAngle)))
	transform.y = Vector2(cos(deg_to_rad(targetAngle + 90)), sin(deg_to_rad(targetAngle + 90)))
	
func ApplyRotationMatrix(angle_rad:float) -> void:
	var rotMatrix:PackedVector2Array = [Vector2(cos(angle_rad),-sin(angle_rad)),
										 Vector2(sin(angle_rad),cos(angle_rad))]
	
	
	"""
	var tempVectorX:Vector2 = transform.x
	var tempVectorY:Vector2 = transform.y
	transform.x.x = (tempVectorX.x * cos(angle_rad)) - (tempVectorX.y * sin(angle_rad))
	transform.x.y = (tempVectorX.x * sin(angle_rad)) + (tempVectorX.y * cos(angle_rad))
	transform.y.x = (tempVectorY.x * cos(angle_rad)) - (tempVectorY.y * sin(angle_rad))
	transform.y.y = (tempVectorY.x * sin(angle_rad)) + (tempVectorY.y * cos(angle_rad))
	"""
	
	#This fails because it's changing the variables that are used mid calculation,
	#messing up the calculation as it goes
	"""
	transform.x.x = (transform.x.x * cos(angle_rad)) - (transform.x.y * sin(angle_rad))
	transform.x.y = (transform.x.x * sin(angle_rad)) + (transform.x.y * cos(angle_rad))
	transform.y.x = (transform.y.x * cos(angle_rad)) - (transform.y.y * sin(angle_rad))
	transform.y.y = (transform.y.x * sin(angle_rad)) + (transform.y.y * cos(angle_rad))
	"""
	
	"""
	transform.x = Vector2((transform.x.x * cos(angle_rad)) - (transform.x.y * sin(angle_rad)),
						  (transform.x.x * sin(angle_rad)) + (transform.x.y * cos(angle_rad)))
	transform.y = Vector2((transform.y.x * cos(angle_rad)) - (transform.y.y * sin(angle_rad)),
						  (transform.y.x * sin(angle_rad)) + (transform.y.y * cos(angle_rad)))
	"""
	
	#This uses the actual rotation matrix
	transform.x = Vector2(rotMatrix[0][0]*transform[0][0] + rotMatrix[0][1]*transform[0][1],
						  rotMatrix[1][0]*transform[0][0] + rotMatrix[1][1]*transform[0][1])
	transform.y = Vector2(rotMatrix[0][0]*transform[1][0] + rotMatrix[0][1]*transform[1][1],
						  rotMatrix[1][0]*transform[1][0] + rotMatrix[1][1]*transform[1][1])
	
func UpdateLabel() -> void:
	text.text = (
					"Origin: " + str(transform.origin) + "\n" +
					"Transform x: " + str(transform.x) + "\n" +
					"Transform y: " + str(transform.y) + "\n" +
					"Transform Skew: " + str(transform.get_skew()) + "\n" +
					"Transform Scale: " + str(transform.get_scale()) + "\n" +
					"Angle: " + str(transform.get_rotation()) + "\n" +
					"Target Angle: " + str(targetAngle)
				)
