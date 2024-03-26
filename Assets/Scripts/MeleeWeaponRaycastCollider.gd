extends Node2D
@export var enabled:bool = false
@export var excludeCollision:Array[CollisionObject2D]
@export var weaponDamage:int = 10
@export var weaponKnockback:float = 400
var wielder:Node2D #Stores the object that this collider's weapon is attached to
var raycastNodes:Array[RaycastNodeData]
var excludeCollisionRIDs:Array[RID] #Rids to always ignore
var hitRIDs:Array[RID] #RIDs to ignore because they were already hit this attack
var debugInfo:DebugInfo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	debugInfo = get_tree().get_root().get_node("World2D") as DebugInfo
	InitRaycastNodes()
	#TODO: make this more dynamic somehow...
	wielder = get_parent().get_parent()
	for excluded:CollisionObject2D in excludeCollision:
		excludeCollisionRIDs.append(excluded.get_rid())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(!enabled):
		return
	for nodeData:RaycastNodeData in raycastNodes:
		if(debugInfo.debugUIEnabled):
			DrawDebugTrail(nodeData)
		nodeData.UpdatePrevPos()

func _physics_process(_delta: float) -> void:
	if(!enabled):
		return
	#Get the physics space
	var spaceState:PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var queuedHits:Array[HitData] = []
	#Update all raycastNode's hit information
	for nodeData:RaycastNodeData in raycastNodes:
		nodeData.UpdateHitResult(spaceState, excludeCollisionRIDs)
		#queue hits to be processed
		for hitResult:Dictionary in nodeData.hitResults:
			#Check if hit is already queued from another node's data
			for queuedHit:HitData in queuedHits:
				if(queuedHit.rid == hitResult.rid):
					continue
			#If hit isn't already queued by another node, add it to the queue
			#queuedHits.append(GenerateHitData(hitResult, nodeData.node.global_position - nodeData.prevPos))
			queuedHits.append(HitData.new(hitResult, nodeData.node.global_position - nodeData.prevPos, wielder.global_transform.x, weaponDamage, weaponKnockback))
	
	#Process all queued hits
	for queuedHit:HitData in queuedHits:
		#TODO: Expand this to work for any "hittableObject" and consider some kind of "sturdiness" value
		if(queuedHit.collider is StaticBodyHittable):
			(queuedHit.collider as StaticBodyHittable).HandleHit(queuedHit)
			break
		if(queuedHit.collider is RigidBodyHittable && hitRIDs.find(queuedHit.rid) == -1 ):
			(queuedHit.collider as RigidBodyHittable).HandleHit(queuedHit)
			hitRIDs.append(queuedHit.rid)

#Allows the weapon to hit objects that were hit previously
func ClearHits() -> void:
	hitRIDs.clear()

func Disable() -> void:
	enabled = false
	ClearHits()

func Enable() -> void:
	enabled = true
	for nodeData:RaycastNodeData in raycastNodes:
		nodeData.UpdatePrevPos()

func InitRaycastNodes() -> void:
	var nodesTemp:Array[Node] = get_children()
	var nodesTempSize:int = nodesTemp.size()
	raycastNodes.resize(nodesTempSize)
	for i:int in nodesTempSize:
		raycastNodes[i] = RaycastNodeData.new(nodesTemp[i] as Node2D)

func DrawDebugTrail(pNodeData:RaycastNodeData) -> void:
	var lineColor:Color = Color.GREEN #Default debug line color
	if(!pNodeData.hitResults.is_empty()):
		lineColor = Color.RED
	#Draw debug line
	get_node("/root").add_child(DebugLine.new(pNodeData.prevPos, pNodeData.node.global_position, lineColor))

"""
#Not needed since the constructor does all the work
func GenerateHitData(pHitResult:Dictionary, pSwingDirection:Vector2) -> HitData:
	return HitData.new(pHitResult, pSwingDirection, wielder.global_transform.x, weaponDamage, weaponKnockback)
"""
"""
#Old GenerateHitData that uses a dictionary
func GenerateHitData(pHitResult:Dictionary, pSwingDirection:Vector2) -> Dictionary:
	var hitData:Dictionary = pHitResult.duplicate(true)
	hitData.swingDirection = pSwingDirection
	hitData.lookDirection = wielder.global_transform.x
	hitData.damage = weaponDamage
	hitData.knockback = weaponKnockback
	return hitData
"""

class RaycastNodeData:
	var node:Node2D
	var prevPos:Vector2
	var hitResults:Array[Dictionary]

	func _init(pNode:Node2D) -> void:
		node = pNode
		UpdatePrevPos()

	func UpdatePrevPos() -> void:
		prevPos = node.global_position

	func UpdateHitResult(pSpaceState:PhysicsDirectSpaceState2D, pExclude:Array[RID]) -> void:
		#Raycast collision check
		var query:PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(prevPos, node.global_position)
		query.exclude = pExclude
		query.hit_from_inside = true
		hitResults = RaycastHelper.RaycastAll(pSpaceState, query)
