class_name Geometry2DHelper
#CreatePolygonFromSprite modified from: https://gist.github.com/hiulit/180e0623989d344878207313d062be9f
#Some inspiration from: https://github.com/bartekd97/gdDelaunay/blob/main/addons/gdDelaunay/Delaunay.gd

# The sprite parameter must be a Sprite node.
static func CreatePolygonFromSprite(pSprite:Sprite2D, pEpsilon:float = 1.0) -> Array[Polygon2D]:
	var ret:Array[Polygon2D] = []
	# Get the sprite's texture.
	var texture:Texture2D = pSprite.texture
	# Get the sprite texture's size.
	var texture_size:Vector2 = pSprite.texture.get_size()
	# Get the image from the sprite's texture.
	var image:Image = texture.get_image()

	# Create a new bitmap.
	var bitmap:BitMap = BitMap.new()
	# Create the bitmap from the image. We set the minimum alpha threshold.
	bitmap.create_from_image_alpha(image, 0.01) # 0.1 (default threshold).
	# Get the rect of the bitmap.
	var bitmap_rect:Rect2 = Rect2(Vector2(0, 0), bitmap.get_size())
	# Grow the bitmap if you need (we don't need it in this case).
#	bitmap.grow_mask(0, rect) # 2
	# Convert all the opaque parts of the bitmap into polygons.
	var polygons:Array[PackedVector2Array] = bitmap.opaque_to_polygons(bitmap_rect, pEpsilon) # 2 (default epsilon).

	# Check if there are polygons.
	if polygons.size() > 0:
		# Loop through all the polygons.
		for i in range(polygons.size()):
			# Create a new 'Polygon2D'.
			var polygon:Polygon2D = Polygon2D.new()
			# Set the polygon.
			polygon.polygon = polygons[i]
			# Set the texture.
			polygon.texture = texture
			
			#Check if the sprite is centered and alter the polygon and texture data accordingly
			if pSprite.centered:
				polygon.texture_offset = texture_size/2
				var translateXForm:Transform2D = Transform2D(0, -polygon.texture_offset)
				polygon.polygon = translateXForm * polygon.polygon

			#Scale the polygon data according to the sprite
			var scaleXForm:Transform2D = Transform2D()
			scaleXForm = scaleXForm.scaled(pSprite.scale)
			polygon.polygon = scaleXForm * polygon.polygon
			
			#Scale the texture and alter the offset accordingly
			polygon.texture_scale = Vector2.ONE / (pSprite.scale)
			polygon.texture_offset /= polygon.texture_scale

			polygon.name = "poly_sprite"

			ret.append(polygon)
	return ret

static func GetClipperPolys_Deluany(pBasePoly:Polygon2D) -> Array[Polygon2D]:
	var clippers:Array[Polygon2D] = []
	var bounds:Rect2 = GetBoundingRect(pBasePoly.polygon)
	var boundingRect:PackedVector2Array = GetPolygonFromRect(bounds)
	var center:Vector2 = bounds.get_center()
	
	for i in range(0, randi_range(3, 6)):
		boundingRect.append(Vector2(randf_range(-bounds.size.x/3, bounds.size.x/3), randf_range(-bounds.size.y/3, bounds.size.y/3)) + center)

	var delaunyInfo:PackedInt32Array = Geometry2D.triangulate_delaunay(boundingRect)
	var clipperPolyData:PackedVector2Array = []
	var count:int = 0
	var clipper:Polygon2D
	for i in range(delaunyInfo.size()):
		clipperPolyData.append(boundingRect[delaunyInfo[i]])
		count += 1
		if(count == 3):
			clipper = Polygon2D.new()	
			clipper.polygon = clipperPolyData
			#Debugging
			#clipper.color = Color(float(i+1)/float(delaunyInfo.size()), 0, 0)
			#clipper.z_index = 100
			clippers.append(clipper)
			count = 0
			clipperPolyData = []
	return clippers

static func GetClipperPolys_RandomCracks(pBasePoly:Polygon2D) -> Array[Polygon2D]: #, pDebugParentNode:Node2D) -> Array[Polygon2D]:
	var clippers:Array[Polygon2D] = []
	var bounds:Rect2 = GetBoundingRect(pBasePoly.polygon)
	var boundsPoly:PackedVector2Array = GetPolygonFromRect(bounds)
	boundsPoly.reverse()
	var center:Vector2 = bounds.get_center()
	
	#Get center clipper polygon
	var centerClipper:Polygon2D = Polygon2D.new()
	centerClipper.polygon = GenerateRandomPolygon(center, Vector2(minf(bounds.size.x/8, bounds.size.y/8), minf(bounds.size.x/4, bounds.size.y/4)), randi_range(4,10))
	#Debugging
	#centerClipper.color.a = 0.25
	#pDebugParentNode.add_child(centerClipper)
	clippers.append(centerClipper)
	
	#Get outer clipper polygons
	var lineCount:int = randi_range(3,6)
	var zigZagCount:int
	var angle:float = 2*PI/float(lineCount)
	var initialAngle:float = randf_range(0, PI/2)
	var clipper:Polygon2D
	var clipperPolyData:PackedVector2Array
	var clipperLines:Array[PackedVector2Array] = []
	var zigZagPos:Vector2
	var zigZagPerpendicular:Vector2
	var zigZagMaxOffset:float = min(bounds.size.x, bounds.size.y) * 0.1
	var zigZagOffset:float
	#var lineDebug:Line2D
	var zigZagDir:float
	var zigZagWeight:float
	#Generate lines
	for i in range(lineCount):
		#Initialize new line
		clipperLines.append(PackedVector2Array())
		#Add outer edge point
		clipperLines[i].append(ProjectAngleFromCenterToRect(bounds, i*angle+initialAngle))
		#zigZagDir = -1 if randi_range(0, 1) == 0 else 1
		zigZagDir = 2 * randi_range(0,1) - 1
		
		#Add zig zags
		zigZagCount = randi_range(2, 3)
		for j in zigZagCount:
			#zigZagWeight = clampf(float(j)/float(zigZagCount), 0.2, 0.8)
			zigZagWeight = ((float(j)/float(zigZagCount)) * 0.6) + 0.2
			zigZagOffset = lerp(zigZagMaxOffset, 0.0, zigZagWeight)
			zigZagPos = lerp(clipperLines[i][0], center, zigZagWeight)
			zigZagPerpendicular = Vector2(clipperLines[i][0].y, -clipperLines[i][0].x).normalized()
			clipperLines[i].append(zigZagPos + zigZagPerpendicular * zigZagOffset * zigZagDir)
			zigZagDir *= -1
			pass
		#Add center point
		clipperLines[i].append(center)
		
		#lineDebug = Line2D.new()
		#lineDebug.points = clipperLines[i]
		#lineDebug.width = 1
		#lineDebug.name = "Line_" + str(i)
		#pDebugParentNode.add_child(lineDebug)
		
	#Loop through lines and generate polygons with them
	var nextLine:PackedVector2Array
	var line1:Vector2
	var line2:Vector2
	for i:int in range(lineCount):
		clipperPolyData = []
		clipperPolyData.append_array(clipperLines[i])
		#get the next line in the sequence to pair with this line
		if(i == lineCount - 1):
			nextLine = clipperLines[0].duplicate()
		else:
			nextLine = clipperLines[i+1].duplicate()
		#Get next line before altering to sequence it into the polygon correctly
		line2 = nextLine[0]-center
		
		#Modify the next line's data to sequence it into the polygon correctly and add it to the array
		nextLine.reverse()
		nextLine.remove_at(0)
		clipperPolyData.append_array(nextLine)
		
		#Check if a bounding corner should be part of this clipper
		line1 = clipperPolyData[0]-center
		for corner:Vector2 in boundsPoly:
			if(VectorBetween(corner, line1, line2)):
				clipperPolyData.append(corner)
	
		clipper = Polygon2D.new()
		clipperPolyData = Geometry2D.clip_polygons(clipperPolyData, centerClipper.polygon)[0]
		clipper.polygon = clipperPolyData
		#Debugging
		#clipper.color.a = 0.25
		#clipper.color.r = i*0.2
		#clipper.color.g = 1 - (lineCount-i * 0.1)
		#clipper.name = "clipper_" + str(i)
		#pDebugParentNode.add_child(clipper)
		clippers.append(clipper)
	
	return clippers
	
static func GenerateRandomPolygon(pCenter:Vector2, pRadiusRange:Vector2, pPoints:int) -> PackedVector2Array:
	var ret:PackedVector2Array = []
	var angle:float = 2*PI/float(pPoints)
	for i in range(pPoints):
		ret.append(Vector2.from_angle(angle * i) * randf_range(pRadiusRange.x, pRadiusRange.y) + pCenter)
	
	return ret

static func VectorBetween(pVector:Vector2, pVa:Vector2, pVb:Vector2) -> bool:
	#https://stackoverflow.com/questions/13640931/how-to-determine-if-a-vector-is-between-two-other-vectors
	#AxB * AxC >= 0 && CxB * CxA >= 0
	#A = pVa, B = pVector, C = pVb
	return pVa.cross(pVector) * pVa.cross(pVb) >= 0 && pVb.cross(pVector) * pVb.cross(pVa) >= 0

static func NormalizeAngle(pAngle:float) -> float:
	pAngle = fmod(pAngle, 2*PI)
	pAngle = fmod(pAngle + 2*PI, 2*PI)
	return pAngle

static func GenerateRandomConvexPolygon_Lazy(pBounds:Rect2) -> PackedVector2Array:
	var ret:PackedVector2Array = []
	#var halfBounds:Vector2 = Vector2(pBounds.size.x/2, pBounds.size.y/2)
	#for i in randi_range(4, 10):
	#	ret.append(Vector2(randf_range(-halfBounds.x, halfBounds.x) + pBounds.position.x, randf_range(-halfBounds.y, halfBounds.y) + pBounds.position.y))
	ret.append(Vector2(0, -pBounds.size.y/2) + pBounds.get_center())
	ret.append(-pBounds.size/2 + pBounds.get_center())
	ret.append(pBounds.get_center())
	
	#ret = Geometry2D.convex_hull(ret)
	return ret

static func GetPolygonFromRect(pBounds:Rect2) -> PackedVector2Array:
	var ret:PackedVector2Array = []
	var center:Vector2 = pBounds.get_center()
	var minVect:Vector2 = -pBounds.size/2.0 + center
	var maxVect:Vector2 = pBounds.size/2.0 + center
	
	ret.append(minVect)
	ret.append(Vector2(maxVect.x, minVect.y))
	ret.append(maxVect)
	ret.append(Vector2(minVect.x, maxVect.y))

	return ret

static func GetBoundingRect(pPoly:PackedVector2Array, padding:float = 0.0) -> Rect2:
	var rect := Rect2(pPoly[0], Vector2.ZERO)
	for point in pPoly:
		rect = rect.expand(point)
	return rect.grow(padding)

static func CreateChunks(pBasePoly:Polygon2D, pClipper:Polygon2D) -> Array[Polygon2D]:
	var ret:Array[Polygon2D] = []
	var transformedClipper:PackedVector2Array = pClipper.polygon.duplicate()
	#var tForm:Transform2D = pClipper.transform * pBasePoly.transform
	#transformedClipper = tForm*transformedClipper
	
	var polyData:Array[PackedVector2Array] = Geometry2D.intersect_polygons(pBasePoly.polygon,transformedClipper)
	var poly:Polygon2D
	for data in polyData:
		poly = pBasePoly.duplicate()
		poly.polygon = data
		poly.polygons = []
		poly.visible = true
		ret.append(poly)
	return ret

static func CreateOutlineFromPolygon(pPoly:PackedVector2Array, pWdith:float = 1.0, pColor:Color = Color.BLACK) -> Line2D:
	var ret:Line2D = Line2D.new()
	ret.points = pPoly
	ret.default_color = pColor
	ret.width = pWdith
	ret.closed = true
	ret.antialiased = true
	return ret

#https://stackoverflow.com/questions/53761001/rotating-line-inside-rectangle-bounds
static func ProjectAngleFromCenterToRect(pRect:Rect2, pAngle:float) -> Vector2:
	var center:Vector2 = pRect.size/2 
	var v:Vector2 = Vector2.from_angle(pAngle) #Vector2(cos(pAngle), sin(pAngle))

	#potential border positions
	var e:Vector2 = Vector2(pRect.size.x if v.x > 0 else 0.0, pRect.size.y if v.y > 0 else 0.0)

	#check for horizontal/vertical directions
	if v.x == 0:
		return Vector2(center.x, e.y) + pRect.position
	if v.y == 0:
		return Vector2(e.x, center.y) + pRect.position

	#in general case find times of intersections with horizontal and vertical edge line
	var t:Vector2 = e - center
	t.x /= v.x
	t.y /= v.y

	#and get intersection for smaller parameter value
	if(t.x <= t.y):
		return Vector2(e.x, center.y + t.x * v.y) + pRect.position
	else:
		return Vector2(center.x + t.y * v.x, e.y) + pRect.position

static func CreateRigidbodyFromPolygon(pPolygon:Polygon2D) -> RigidBody2D:
	var ret:RigidBody2D = RigidBody2D.new()
	var collider:CollisionPolygon2D = CollisionPolygon2D.new()
	var center:Vector2
	var xForm:Transform2D
	collider.polygon = Geometry2D.convex_hull(pPolygon.polygon)
	center = GetBoundingRect(collider.polygon).get_center()
	ret.position = center
	xForm = Transform2D(0, center)
	pPolygon.polygon *= xForm
	pPolygon.texture_offset += center
	collider.polygon *= xForm
	
	ret.add_child(pPolygon)
	ret.add_child(collider)
	
	var outline:Line2D = CreateOutlineFromPolygon(pPolygon.polygon, 0.5)
	outline.name = "outline"
	ret.add_child(outline)
	
	ret.set_script(load("res://Assets/Scripts/SpriteExploder/FadeOut_ExplodedPoly.gd"))
	
	return ret

static func ExplodeSprite(pSprite:Sprite2D, pForceDir:Vector2 = Vector2.ZERO, pForceRange:Vector2 = Vector2.ZERO, pAngularVelRange:Vector2 = Vector2.ZERO, pBasePoly:Polygon2D = null, pCollisionLayers:int = 0, pCollsionMask:int = 1) -> Array[RigidBody2D]:
	var ret:Array[RigidBody2D] = []
	var basePoly:Polygon2D = pBasePoly
	if(basePoly == null):
		basePoly = CreatePolygonFromSprite(pSprite)[0]
	var clipperPolys:Array[Polygon2D]
	#clipperPolys = GetClipperPolys_Deluany(basePoly)
	clipperPolys = GetClipperPolys_RandomCracks(basePoly) #, pSprite.get_tree().get_root().get_child(0))
	
	var chunkShapes:Array[Polygon2D]
	var chunkBody:RigidBody2D
	var xForm:Transform2D = Transform2D(pSprite.global_rotation, pSprite.global_position)
	for i in range(clipperPolys.size()):
		chunkShapes = CreateChunks(basePoly, clipperPolys[i])
		for chunkShape in chunkShapes:
			chunkBody = CreateRigidbodyFromPolygon(chunkShape)
			chunkBody.collision_layer = pCollisionLayers
			chunkBody.collision_mask = pCollsionMask
			chunkBody.global_transform = xForm * chunkBody.global_transform
			chunkBody.angular_velocity = randf_range(pAngularVelRange.x, pAngularVelRange.y)
			if(pForceDir == Vector2.ZERO):
				chunkBody.apply_central_impulse(((chunkBody.global_position-pSprite.global_position).normalized() * randf_range(pForceRange.x, pForceRange.y)))
			else:
				chunkBody.apply_central_impulse(pForceDir * randf_range(pForceRange.x, pForceRange.y))
			#pSprite.get_tree().get_root().get_child(0).add_child(chunkBody)
			if(pSprite.get_tree().current_scene == null):
				pSprite.get_owner().add_child(chunkBody)
			else:
				pSprite.get_tree().current_scene.add_child(chunkBody)
			ret.append(chunkBody)
	return ret

#Converts data of an Array of PackedVector2Arrays into a single PackedVector2Array and an Array[PackedInt32Array]
#to populate a Polygon2D with multiple polygons
static func ConvertMultiPolygonData(pData:Array[PackedVector2Array]) -> Dictionary:
	var ret:Dictionary = Dictionary()
	var pointData:PackedVector2Array = []
	var indexData:Array[PackedInt32Array] = []
	
	var startIndex:int = 0
	for i in range(pData.size()):
		pointData.append_array(pData[i])
		indexData.append(PackedInt32Array(range(startIndex, pointData.size())))
		startIndex = pointData.size()
	
	ret["polygon"] = pointData
	ret["polygons"] = indexData
		
	return ret

static func minv(curVec:Vector2, newVec:Vector2) -> Vector2:
	return Vector2(minf(curVec.x, newVec.x), minf(curVec.y, newVec.y))

static func maxv(curVec:Vector2, newVec:Vector2) -> Vector2:
	return Vector2(maxf(curVec.x, newVec.x), maxf(curVec.y, newVec.y))
