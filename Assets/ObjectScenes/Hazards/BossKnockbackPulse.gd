extends HazardStatic
class_name KnockbackPulse

@onready var knockbackVFX:Polygon2D = $KnockbackVFX
@onready var shapeCast2D:ShapeCast2D = $ShapeCast2D

@export var timeToExpand:float = 1.5
@export var timeToCollide:float = 1.4
@export var hitCooldownTime:float = 0.1

#var gradient:Gradient
var shaderVFX:ShaderMaterial
var active:bool = false:
	get:
		return active
	set(value):
		if(active != value):
			active = value
			shapeCast2D.enabled = active
var currentTime:float = 0
var maxCollisionRadius:float = 1500
var collisionRingThickness:float = 0.05
var collisionRingThicknessHalf:float = collisionRingThickness/2
#var ringThicknessHalf:float = 0.05
#var collisionRingThicknessHalf:float = 0.03
#var collisionThicknessDiff:float = ringThicknessHalf-collisionRingThicknessHalf
var collisionShape:CircleShape2D
var collisionRingRange:Vector2
var originatorRID:RID
var hitRIDs:Array[RID] #RIDs to ignore because they were already hit this attack
var hitRIDResetTimers:Array[float] #Time left to ignore hit per RID
var raycastStartPosOffsets:Array[float]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(originator is PhysicsBody2D):
		originatorRID = (originator as PhysicsBody2D).get_rid()
	#gradient = (knockbackVFX.texture as GradientTexture2D).gradient
	shaderVFX = knockbackVFX.material
	collisionShape = shapeCast2D.shape
	ClearCollisions()
	UpdateRing()#.bind(0).call_deferred()
	shaderVFX.set_shader_parameter("radius", -0.1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	if(!active):
		return
	UpdateTimer(delta)
	HandleHitRIDResetTimers(delta)
	UpdateRing()
	#if(shapeCast2D.enabled):
		#queue_redraw()


func _physics_process(_delta:float) -> void:
	if(!active || currentTime > timeToCollide):
		if(shapeCast2D.enabled):
			shapeCast2D.enabled = false
		return
	CollisionCheck()


func UpdateTimer(pDelta:float) -> void:
	currentTime += pDelta
	if(currentTime >= timeToExpand):
		currentTime = timeToExpand
		active = false


func UpdateRing() -> void:
	var percentageComplete:float = GetPercentageComplete()
	#var minMaxRingSizePercentage:Vector2
	#minMaxRingSizePercentage = UpdateRingSizeVisual(percentageComplete)
	#UpdateRingAlpha(percentageComplete)
	#collisionRingRange = GetCollisionRingMinMaxRadius(minMaxRingSizePercentage)
	UpdateRingSizeVisual(percentageComplete)
	collisionRingRange = GetCollisionRingMinMaxRadius(percentageComplete)
	collisionShape.radius = collisionRingRange.y


func UpdateRingSizeVisual(pPercent:float) -> void:
	#size = clampf(0.1, 0.9, pPercent)
	#var minMaxRingSizePercentage:Vector2
	#var size:float = (1 + 2*ringThicknessHalf)*pPercent - ringThicknessHalf
	#minMaxRingSizePercentage.x = clampf(size - ringThicknessHalf, 0, 0.99)
	#minMaxRingSizePercentage.y = clampf(size + ringThicknessHalf, 0, 0.99)
	shaderVFX.set_shader_parameter("radius", pPercent)
	#return minMaxRingSizePercentage
	#gradient.offsets[0] = minMaxRingSizePercentage.x
	#gradient.offsets[1] = clampf(size, 0, 0.99)
	#gradient.offsets[2] = minMaxRingSizePercentage.y
	#return minMaxRingSizePercentage


func UpdateRingAlpha(pPercent:float) -> void:
	if(pPercent >= 0.5):
		knockbackVFX.modulate.a = 1 - ((pPercent-0.5) / 0.4)


func GetCollisionRingMinMaxRadius(pPercentage:float) -> Vector2:
	var minMaxRadius:Vector2
	#pMinMaxRingSizePercentage.x = clampf(pMinMaxRingSizePercentage.x + collisionThicknessDiff, 0, minf(0.99, pMinMaxRingSizePercentage.y))
	#pMinMaxRingSizePercentage.y = clampf(pMinMaxRingSizePercentage.y - collisionThicknessDiff, maxf(0, pMinMaxRingSizePercentage.x), 0.99)
	#pMinMaxRingSizePercentage.x = clampf(pMinMaxRingSizePercentage.x, 0, pMinMaxRingSizePercentage.y)
	#pMinMaxRingSizePercentage.y = clampf(pMinMaxRingSizePercentage.y, pMinMaxRingSizePercentage.x, 0.99)
	#minMaxRadius.x = pMinMaxRingSizePercentage.x * maxCollisionRadius
	#minMaxRadius.y = pMinMaxRingSizePercentage.y * maxCollisionRadius
	#minMaxRadius.x = (pMinMaxRingSizePercentage.x - collisionRingThicknessHalf) * maxCollisionRadius
	#minMaxRadius.y = (pMinMaxRingSizePercentage.y + collisionRingThicknessHalf) * maxCollisionRadius
	var percentageScaled:float = ((1.0 + collisionRingThickness)*pPercentage)-collisionRingThickness
	minMaxRadius.x = clampf(percentageScaled - collisionRingThicknessHalf, 0, 1) * maxCollisionRadius
	minMaxRadius.y = clampf(percentageScaled + collisionRingThicknessHalf, 0, 1) * maxCollisionRadius
	return minMaxRadius


func CollisionCheck() -> void:
	var hitResult:Dictionary
	var hitPosition:Vector2
	var hitVector:Vector2
	for i in range(0, shapeCast2D.collision_result.size()):
		hitResult = shapeCast2D.collision_result[i]
		if(hitResult.collider is not RigidBodyHittable):
			continue
		hitPosition = shapeCast2D.get_collision_point(i)
		hitVector = hitPosition - global_position
		if(hitVector.length() >= collisionRingRange.x):
			hitResult["position"] = hitPosition
			hitResult["direction"] = hitVector.normalized()
			HandleHit(hitResult)


#func _draw() -> void:
	#var radii:Vector2
	##radii.x = GetPercentageComplete()
	##radii.y = GetPercentageComplete()
	##radii = GetCollisionRingMinMaxRadius(radii)
	#radii = collisionRingRange
	#draw_circle(Vector2.ZERO, radii.x, Color.BLUE, false, 4)
	#draw_circle(Vector2.ZERO, radii.y, Color.RED, false, 4)


func Fire() -> void:
	currentTime = 0
	ClearCollisions()
	UpdateRing()
	active = true
	shapeCast2D.force_shapecast_update()
	#knockbackVFX.modulate.a = 1


func GetPercentageComplete() -> float:
	return clamp(0, 1, currentTime/timeToExpand)


func HandleHit(pHitResult:Dictionary) -> void:
	var ridCast:RID = pHitResult.rid
	shapeCast2D.add_exception_rid(ridCast)
	hitRIDs.append(pHitResult.rid)
	hitRIDResetTimers.append(hitCooldownTime)
	#var hitResultPosCast:Vector2 = pHitResult.position
	on_hit(pHitResult)


func HandleHitRIDResetTimers(pDelta:float) -> void:
	var timersCompleted:Array[int] = []
	for i:int in range(hitRIDResetTimers.size()):
		hitRIDResetTimers[i] -= pDelta
		if(hitRIDResetTimers[i] <= 0):
			timersCompleted.append(i)
	timersCompleted.reverse()
	for index:int in timersCompleted:
		shapeCast2D.remove_exception_rid(hitRIDs[index])
		hitRIDResetTimers.remove_at(index)
		hitRIDs.remove_at(index)


func ClearCollisions() -> void:
	hitRIDs.clear()
	hitRIDResetTimers.clear()
	shapeCast2D.clear_exceptions()
	shapeCast2D.add_exception_rid(originatorRID)
