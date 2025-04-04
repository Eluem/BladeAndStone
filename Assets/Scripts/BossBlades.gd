extends Node2D
class_name BossBlades
@onready var bladeSpike:Sprite2D = $"../../Visuals/Blade_Spike"
#@onready var bladeInnerLeft:Sprite2D = $"../../Visuals/Blade_InnerLeft"
#@onready var bladeInnerRight:Sprite2D = $"../../Visuals/Blade_InnerRight"
#@onready var bladeOuterLeft:Sprite2D = $"../../Visuals/Blade_OuterLeft"
#@onready var bladeOuterRight:Sprite2D = $"../../Visuals/Blade_OuterRight"
@onready var raycastCollider: RaycastCollider = $RaycastCollider

@export var trailMaxLength:int = 150

var trails:Array[Trail]
var bladeMaterial:ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bladeMaterial = bladeSpike.material
	PopulateTrails()


func Activate() -> void:
	raycastCollider.Enable()
	EnableTrails()


func Deactivate() -> void:
	raycastCollider.Disable()
	DisableTrails()


func EnableTrails() -> void:
	for trail:Trail in trails:
		trail.MAX_LENGTH = trailMaxLength
		#trail.trackingEnabled = true


func DisableTrails() -> void:
	for trail:Trail in trails:
		trail.MAX_LENGTH = 0
		#trail.trackingEnabled = false


#func SetTrailsTracking(pEnabled:bool) -> void:
	#for trail:Trail in trails:
		#trail.trackingEnabled = pEnabled


func ResetVisuals() -> void:
	bladeMaterial.set_shader_parameter("heat", 0)


func PopulateTrails() -> void:
	trails = []
	trails.append($"../../Visuals/Blade_Spike/TrailTarget/ThrustTrail")
	trails.append($"../../Visuals/Blade_InnerLeft/TrailTarget/Trail")
	trails.append($"../../Visuals/Blade_InnerRight/TrailTarget/Trail")
	trails.append($"../../Visuals/Blade_OuterLeft/TrailTarget/Trail")
	trails.append($"../../Visuals/Blade_OuterRight/TrailTarget/Trail")
