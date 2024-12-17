extends Control
class_name MaxSizeLimiter

@onready var virtualLogo:TextureRect = $"../../Virtual/Logo"
@onready var centeringBuffer:Control = $"../CenteringBuffer"


@export var maxSize:Vector2
var initialCustomMinimumSize:Vector2
var oversized:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialCustomMinimumSize = custom_minimum_size
	virtualLogo.resized.connect(limit_size)


func _process(_delta: float) -> void:
	#print(size)
	pass

func limit_size() -> void:
	centeringBuffer.custom_minimum_size.y = (virtualLogo.size.y-size.y) * (2.0/3.0)
	if(!oversized && ((virtualLogo.size.x > maxSize.x && maxSize.x > -1) || (virtualLogo.size.y > maxSize.y && maxSize.y > -1))):
		custom_minimum_size = maxSize
		size_flags_vertical -= SIZE_EXPAND
		oversized = true
	elif(oversized && ((virtualLogo.size.x <= maxSize.x || maxSize.x <= -1)  && (virtualLogo.size.y <= maxSize.y || maxSize.y <= -1))):
		custom_minimum_size = initialCustomMinimumSize
		size_flags_vertical += SIZE_EXPAND
		oversized = false
