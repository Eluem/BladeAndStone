extends RigidBody2D
class_name Hazard
@export var damage:int
@export var knockback:float
@export var lifetime:float = 5
@export var destroySelfOnHit:bool = true
var originator:Node2D:
	get:
		return originator
	set(pValue):
		originator = pValue
		if(originator):
			originator.tree_exited.connect(originator_destroyed)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Collider.connect("on_hit", on_hit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	lifetime -= delta
	if(lifetime <= 0):
		lifetime_end()
	
func on_hit(pHitResult:Dictionary) -> void:
	#Apply damage to hittable objects
	if(pHitResult.collider is RigidBodyHittable):
		var hittable:RigidBodyHittable = pHitResult.collider
		var hitData:HitData = HitData.new(originator, pHitResult, linear_velocity, linear_velocity, damage, knockback)
		hittable.HandleHit(hitData)
	#Handle hitting static hittable objects
	elif(pHitResult.collider is StaticBodyHittable):
		var hittable:StaticBodyHittable = pHitResult.collider
		var hitData:HitData = HitData.new(originator, pHitResult, linear_velocity, linear_velocity, damage, knockback)
		hittable.HandleHit(hitData)
	#Destroy self after hitting
	if(destroySelfOnHit):
		queue_free()

func lifetime_end() -> void:
	queue_free()

func originator_destroyed() -> void:
	originator = null
