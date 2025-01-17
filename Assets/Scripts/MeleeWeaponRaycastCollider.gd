extends Node2D
class_name RaycastCollider

@onready var hitSFXPlayer:AudioStreamPlayer2D = $HitSFXPlayer

@export var enabled:bool = false
@export var excludeCollision:Array[CollisionObject2D]
@export var weaponDamage:int = 10
@export var weaponKnockback:float = 400
@export var hitSFX:Array[AudioStream]

var wielder:Node2D #Stores the object that this collider's weapon is attached to
var weapon:Node2D #Stores the weapon object for this collider
var raycastNodes:Array[RaycastNodeData]
var excludeCollisionRIDs:Array[RID] #Rids to always ignore
var hitRIDs:Array[RID] #RIDs to ignore because they were already hit this attack
var staticHitRIDs:Array[RID] #RIDs to pass true to "alreadyHit"
#var debugInfo:DebugInfo


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#debugInfo = get_tree().get_root().get_node("World2D") as DebugInfo
	#TODO: make these more dynamic somehow?...
	wielder = get_parent().get_parent()
	weapon = get_parent()
	InitRaycastNodes()
	for excluded:CollisionObject2D in excludeCollision:
		excludeCollisionRIDs.append(excluded.get_rid())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	if(!enabled):
		return
	var debugFullScanEmpty:bool = true
	if(DebugInfo.debugUIEnabled || DebugInfo.forceDebugTrails):
		for nodeData:RaycastNodeData in raycastNodes:
			if(!nodeData.hitResults.is_empty()):
				debugFullScanEmpty = false
				break
	for nodeData:RaycastNodeData in raycastNodes:
		if(DebugInfo.debugUIEnabled || DebugInfo.forceDebugTrails):
			DrawDebugTrail(nodeData, debugFullScanEmpty)
		nodeData.UpdatePrevPos()


func _physics_process(_delta:float) -> void:
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
			#queuedHits.append(HitData.new(wielder, hitResult, nodeData.node.global_position - nodeData.prevPos, wielder.global_transform.x, weaponDamage, weaponKnockback))
			queuedHits.append(HitData.new(wielder, hitResult, nodeData.GetSwingDir(), wielder.global_transform.x, weaponDamage, weaponKnockback))
	
	#Process all queued hits
	var staticBodyHittable:StaticBodyHittable #just to hide the unsafe cast warning
	var rigidBodyHittable:RigidBodyHittable #just to hide the unsafe cast warning
	for queuedHit:HitData in queuedHits:
		#TODO: Expand this to work for any "hittableObject" and consider some kind of "sturdiness" value
		if(queuedHit.collider is StaticBodyHittable):
			staticBodyHittable = queuedHit.collider #as StaticBodyHittable #This as also causes unsafe cast
			if(staticHitRIDs.has(queuedHit.rid)):
				queuedHit.alreadyHit = true
			else:
				PlayHitSFX(queuedHit.position)
				staticHitRIDs.append(queuedHit.rid)
				staticHitRIDs.append_array(staticBodyHittable.groupedStaticBodyRIDs)
			staticBodyHittable.HandleHit(queuedHit)
			#(queuedHit.collider as StaticBodyHittable).HandleHit(queuedHit) #Causes unsafe cast
			break
		if(queuedHit.collider is RigidBodyHittable):
			rigidBodyHittable = queuedHit.collider #as RigidBodyHittable #This as also causes unsafe cast
			if(!hitRIDs.has(queuedHit.rid)):
				PlayHitSFX(queuedHit.position)
				rigidBodyHittable.HandleHit(queuedHit)
				#(queuedHit.collider as RigidBodyHittable).HandleHit(queuedHit) #Causes unsafe cast
				hitRIDs.append(queuedHit.rid)
			if(rigidBodyHittable.blockAttacks):
				break


#Allows the weapon to hit objects that were hit previously
func ClearHits() -> void:
	hitRIDs.clear()
	staticHitRIDs.clear()


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
		raycastNodes[i] = RaycastNodeData.new(self, nodesTemp[i] as Node2D, wielder, weapon)


func DrawDebugTrail(pNodeData:RaycastNodeData, pFullScanEmpty:bool) -> void:
	var lineColor:Color = Color.GREEN #Default debug line color
	if(!pNodeData.hitResults.is_empty()):
		lineColor = Color.RED
	if(pFullScanEmpty):
		lineColor = Color.PURPLE
	#Draw debug line
	get_tree().current_scene.add_child(DebugLine.new(pNodeData.prevGlobalPos, pNodeData.node.global_position, lineColor))


func PlayHitSFX(pPosition:Vector2) -> void:
	if(hitSFX.is_empty()):
		return
	var audioStreamCast:AudioStream = hitSFX.pick_random()
	GameStateManager.PlaySFX(pPosition, audioStreamCast, hitSFXPlayer)

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
	var mainCollider:Node2D
	var node:Node2D
	var wielder:Node2D
	var weapon:Node2D
	var currSwingPos:Vector2
	var prevSwingPos:Vector2
	var prevGlobalPos:Vector2
	var hitResults:Array[Dictionary]

	func _init(pMainCollider:Node2D, pNode:Node2D, pWielder:Node2D, pWeapon:Node2D) -> void:
		mainCollider = pMainCollider
		node = pNode
		wielder = pWielder
		weapon = pWeapon
		UpdatePrevPos()
		UpdatePrevPos()


	func UpdatePrevPos() -> void:
		prevSwingPos = currSwingPos
		currSwingPos = GetSwingPos()
		prevGlobalPos = node.global_position


	func UpdateHitResult(pSpaceState:PhysicsDirectSpaceState2D, pExclude:Array[RID]) -> void:
		#Raycast collision check
		var query:PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(prevGlobalPos, node.global_position)
		query.exclude = pExclude
		query.hit_from_inside = true
		hitResults = RaycastHelper.RaycastAll(pSpaceState, query)
	
	
	func GetSwingDir() -> Vector2:
		if(currSwingPos == prevSwingPos):
			#DebugLine.DrawLine(node.get_tree().current_scene, node.global_position, node.global_position + (wielder.transform.x * 100), Color.RED, 1, -1, true, true)
			return wielder.transform.x
		#DebugLine.DrawLine(node.get_tree().current_scene, node.global_position, node.global_position + ((currSwingPos - prevSwingPos).normalized() * 100), Color.GREEN, 1, -1, true, true)
		return currSwingPos - prevSwingPos
	
	
	func GetSwingPos() -> Vector2:
		return weapon.position + mainCollider.position + node.position
	
