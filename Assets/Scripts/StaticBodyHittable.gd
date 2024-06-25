class_name StaticBodyHittable
extends StaticBody2D
var debugInfo:DebugInfo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	debugInfo = get_tree().get_root().get_node("World2D") as DebugInfo

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func HandleHit(pHitData:HitData) -> void:
	HitEffect(pHitData.position, pHitData.hitDirection.normalized() * pHitData.knockback)

func HitEffect(pPosition:Vector2, pForce:Vector2) -> void:
	if(debugInfo.debugUIEnabled):
		DebugLine.DrawLine(get_node("/root"), pPosition, pPosition + pForce, Color.GRAY, 5, 10)
	if(debugInfo.effectsEnabled):
		Sparks.Spawn(get_node("/root"), pPosition, pForce)
