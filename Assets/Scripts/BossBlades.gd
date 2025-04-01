extends Node2D
class_name BossBlades
@onready var bladeSpike:Sprite2D = $"../../Visuals/Blade_Spike"
@onready var bladeInnerLeft:Sprite2D = $"../../Visuals/Blade_InnerLeft"
@onready var bladeInnerRight:Sprite2D = $"../../Visuals/Blade_InnerRight"
@onready var bladeOuterLeft:Sprite2D = $"../../Visuals/Blade_OuterLeft"
@onready var bladeOuterRight:Sprite2D = $"../../Visuals/Blade_OuterRight"

var bladeMaterial:ShaderMaterial
var bladeCharge:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bladeMaterial = bladeSpike.material


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	UpdateVisuals()


func UpdateVisuals() -> void:
	bladeMaterial.set_shader_parameter("heat", CalculateChargePercentage())


func CalculateChargePercentage() -> float:
	return 0
