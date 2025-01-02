class_name StaticBodyHittable
extends StaticBody2D
#var debugInfo:DebugInfo

@export var hitDragSFXPlayer:AudioStreamPlayer2D
@export var hitSFXPlayer:AudioStreamPlayer2D
@export var groupedStaticBodies:Array[StaticBodyHittable]
@export var hitDragSFXRepeatRate:float = 20
@export var hitSparkColor:Color = Color.WHITE
var groupedStaticBodyRIDs:Array[RID]
var lastHitDragSFXTime:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(hitDragSFXPlayer == null):
		hitDragSFXPlayer = get_node_or_null("HitDragSFXPlayer")
	if(hitSFXPlayer == null):
		hitSFXPlayer = get_node_or_null("HitSFX")
	for body:StaticBodyHittable in groupedStaticBodies:
		groupedStaticBodyRIDs.append(body.get_rid())
	#debugInfo = get_tree().get_root().get_node("World2D") as DebugInfo
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	pass


func HandleHit(pHitData:HitData) -> void:
	#HitEffect(pHitData.position, pHitData.hitDirection.normalized() * pHitData.knockback)
	HitEffect(pHitData.position, pHitData.lookDirection.normalized() * pHitData.knockback)
	if(!pHitData.alreadyHit):
		PlayHitSFX(pHitData.position)
	PlayHitDragSFX(pHitData.position)


func HitEffect(pPosition:Vector2, pForce:Vector2) -> void:
	if(DebugInfo.debugUIEnabled):
		DebugLine.DrawLine(get_tree().current_scene, pPosition, pPosition + pForce, Color.GRAY, 5, 10)
	if(DebugInfo.effectsEnabled):
		var sparks:Sparks
		sparks = Sparks.Spawn(get_tree().current_scene, pPosition, pForce, hitSparkColor)
		sparks.z_index = z_index


func PlayHitSFX(pPosition:Vector2) -> void:
	if(hitSFXPlayer == null):
		return
	var hitSFXPlayerClone:AudioStreamPlayer2D = hitSFXPlayer.duplicate()
	add_child(hitSFXPlayerClone)
	hitSFXPlayerClone.global_position = pPosition
	hitSFXPlayerClone.finished.connect(hitSFXPlayerClone.queue_free)
	hitSFXPlayerClone.play()


func PlayHitDragSFX(pPosition:Vector2) -> void:
	if(hitDragSFXPlayer == null):
		return
	var currHitDragSFXTime:float = Time.get_ticks_msec()
	if(currHitDragSFXTime-lastHitDragSFXTime > hitDragSFXRepeatRate):
		var hitDragSFXPlayerClone:AudioStreamPlayer2D = hitDragSFXPlayer.duplicate()
		add_child(hitDragSFXPlayerClone)
		hitDragSFXPlayerClone.global_position = pPosition
		hitDragSFXPlayerClone.finished.connect(hitDragSFXPlayerClone.queue_free)
		hitDragSFXPlayerClone.play()
		lastHitDragSFXTime = currHitDragSFXTime
