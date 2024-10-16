extends Node2D
class_name CrackDamageVisualUpdater
var lines:Array[Line2D]
@export var widthRange:Vector2 = Vector2(0, 20)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var castOwner:RigidBodyHittable = owner
	castOwner.health_changed.connect(update_cracks)
	GetLines()
	update_cracks(castOwner.maxHealth, castOwner.health, null)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	pass

func GetLines() -> void:
	lines = []
	var children:Array[Node] = get_children()
	for child:Node in children:
		if(child is Line2D):
			lines.append(child)

func update_cracks(pMaxHealth:int, pCurrHealth:int, _pHitOwner:Node2D) -> void:
	var weight:float = float(pCurrHealth)/float(pMaxHealth)
	lines[0].gradient.set_offset(1, lerpf(1, 0, weight))
	for crack:Line2D in lines:
		crack.width = lerpf(widthRange.y, widthRange.x, weight)
		#crack.gradient.set_offset(0, lerpf(1, 0, weight))
		#crack.gradient.set_offset(1, lerpf(1, 0, weight))
