@tool
extends Polygon2D
@export var generateInternalPolygons:bool
@export var generateVertexColors:bool
@export var resetToDefaultPolgyon:bool
##Offset values for generating internal vertex rings. Values should be less than zero (so it scales inward).
@export var ringScaling:Array[float] #number of rings determined by size of array
@export var colorPerRing:Array[Color] #this includes the outer ring, length should be ringScaling.Size() + 1
@export var mainPolygon:PackedVector2Array = [] #backs up the main polygon
@export var rings:Array[PackedInt32Array] = [] #stores each generated ring
@export var removeBadPolygons:bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	_GenerateInternalPolygons()
	_GenerateVertexColors()
	_ResetToDefaultPolygon()


func _GenerateInternalPolygons() -> void:
	if(generateInternalPolygons):
		GenerateInternalPolygons()
		generateInternalPolygons = false


func _GenerateVertexColors() -> void:
	if(generateVertexColors):
		GenerateVertexColors()
		generateVertexColors = false

func _ResetToDefaultPolygon() -> void:
	if(resetToDefaultPolgyon):
		ResetToDefaultPolgyon()
		resetToDefaultPolgyon = false

func GenerateInternalPolygons() -> void:
	var newPolygonData:PackedVector2Array = []
	var newPolygons:Array[PackedInt32Array] = []
	
	ClearInternalData()
	newPolygonData = polygon
	if(mainPolygon.size() == 0):
		mainPolygon = polygon.duplicate()
	
	rings.append(range(0, mainPolygon.size()) as PackedInt32Array)
	
	#Generate rings
	var currRings:Array[PackedVector2Array]
	var prevDataSize:int = mainPolygon.size()
	for i:int in range(ringScaling.size()):
		currRings = Geometry2D.offset_polygon(polygon, ringScaling[i], Geometry2D.JOIN_SQUARE)
		for currRing:PackedVector2Array in currRings:
			newPolygonData.append_array(NewPolyDataMinusBadVectors(currRing, newPolygonData))
		rings.append(range(prevDataSize, newPolygonData.size()) as PackedInt32Array)
		prevDataSize = newPolygonData.size()
	
	#Update internal vertex count
	internal_vertex_count = newPolygonData.size() - mainPolygon.size()
	
	newPolygons = GetPolygons(Geometry2D.triangulate_delaunay(newPolygonData))
	#newPolygons = GetPolygons(Geometry2D.triangulate_polygon(newPolygonData))
	
	#Check and clean up external polygons
	if(removeBadPolygons):
		var badPolygons:Array[int] = []
		for i:int in range(newPolygons.size()):
			if(!Geometry2D.is_point_in_polygon(GetCenterOfTriangle(newPolygons[i], newPolygonData), mainPolygon)):
				badPolygons.append(i)
		badPolygons.reverse()
		for i:int in range(badPolygons.size()):
			newPolygons.remove_at(badPolygons[i])
	
	polygon = newPolygonData
	polygons = newPolygons

func GenerateInternalPolygons_old() -> void:
	var newPolygonData:PackedVector2Array = []
	var newPolygons:Array[PackedInt32Array] = []
	
	ClearInternalData()
	newPolygonData = polygon#.duplicate()
	
	var currRing:PackedVector2Array
	var currRingStartIndex:int
	var currRingLength:int
	var prevRingStartIndex:int = 0
	var prevRingLength:int = polygon.size()
	var tempPolygon:PackedInt32Array
	for i:int in range(ringScaling.size()):
		currRing = Geometry2D.offset_polygon(polygon, ringScaling[i], Geometry2D.JOIN_SQUARE)[0]
		currRing = ReorderPolygon(currRing, newPolygonData[prevRingStartIndex])
		newPolygonData.append_array(currRing)
		
		currRingStartIndex = prevRingStartIndex + prevRingLength
		currRingLength = currRing.size()
		
		#loop
		tempPolygon = range(prevRingStartIndex, prevRingStartIndex + prevRingLength)
		tempPolygon.append_array(range(currRingStartIndex + currRingLength - 1, currRingStartIndex - 1, -1))
		newPolygons.append(tempPolygon)
		
		#ends
		tempPolygon = [prevRingStartIndex, prevRingStartIndex + prevRingLength - 1, currRingStartIndex + currRingLength - 1, currRingStartIndex]
		newPolygons.append(tempPolygon)
		
		if(i == ringScaling.size() - 1):
			tempPolygon = range(currRingStartIndex, currRingStartIndex + currRingLength)
			newPolygons.append(tempPolygon)
		
		prevRingLength = currRingLength
		prevRingStartIndex = currRingStartIndex
	
	internal_vertex_count = newPolygonData.size() - polygon.size()
	
	#newPolygons = GetPolygons(Geometry2D.triangulate_delaunay(newPolygonData))
	#newPolygons = GetPolygons(Geometry2D.triangulate_polygon(newPolygonData))
	
	polygon = newPolygonData
	polygons = newPolygons

func GenerateVertexColors() -> void:
	var newVertexColors:PackedColorArray = []
	
	var colorIndex:int = 0
	for ring:PackedInt32Array in rings:
		for index in ring:
			newVertexColors.insert(index, colorPerRing[colorIndex])
		if(colorIndex < colorPerRing.size() - 1):
			colorIndex += 1
	
	#var colorIndex:int
	#for i:int in range(polygon.size()):
		#colorIndex = GetRingIndex(i)
		#if(colorIndex >= colorPerRing.size()):
			#colorIndex = colorPerRing.size() - 1
		#newVertexColors.append(colorPerRing[colorIndex])
	
	vertex_colors = newVertexColors

#Returns the ring index for a passed polygon vector index
func GetRingIndex(pPolyVectIndex:int) -> int:
	for i:int in range(rings.size()):
		if(pPolyVectIndex >= rings[i][0] && pPolyVectIndex <= rings[i][rings[i].size()]):
			return i
	return -1

func GetOverlappingVectors(pNewPolyData:PackedVector2Array, pOriginalPolyData:PackedVector2Array, pOverlapThreshold:float = 0.001) -> PackedInt32Array:
	var ret:PackedInt32Array
	
	#Get overlapping vectors between new data and original data
	for i:int in range(pNewPolyData.size()):
		for j:int in range(pOriginalPolyData.size()):
			if(pNewPolyData[i].distance_to(pOriginalPolyData[j]) <= pOverlapThreshold):
				ret.append(i)
				break
	#Get overlapping vectors in new data relative to itself
	for i:int in range(pNewPolyData.size()):
		for j:int in range(i + 1, pNewPolyData.size()):
			if(pNewPolyData[i].distance_to(pNewPolyData[j]) <= pOverlapThreshold):
				ret.append(i)
				break
	
	#Remove duplicate indexes
	var dupIndexes:PackedInt32Array
	for i:int in range(ret.size()):
		for j:int in range(i+1, ret.size()):
			if(ret[i] == ret[j]):
				dupIndexes.append(i)
				break
	dupIndexes.reverse()
	for index:int in dupIndexes:
		ret.remove_at(index)
	
	return ret

func NewPolyDataMinusBadVectors(pNewPolyData:PackedVector2Array, pOriginalPolyData:PackedVector2Array, pOverlapThreshold:float = 0.001) -> PackedVector2Array:
	var ret:PackedVector2Array = pNewPolyData
	var badVectorIndexes:PackedInt32Array = GetOverlappingVectors(pNewPolyData, pOriginalPolyData, pOverlapThreshold)
	badVectorIndexes.reverse()
	print(badVectorIndexes.size())
	for index:int in badVectorIndexes:
		ret.remove_at(index)
	
	return ret

func ClearInternalData() -> void:
	polygons = []
	internal_vertex_count = 0
	if(mainPolygon.size() > 0):
		polygon = mainPolygon
		mainPolygon = []
	rings = []

func ResetToDefaultPolgyon() -> void:
	ClearInternalData()
	vertex_colors = []
	
func GetPolygons(pTriangulation:PackedInt32Array) -> Array[PackedInt32Array]:
	var ret:Array[PackedInt32Array] = []
	for i:int in range(0, pTriangulation.size(), 3):
		ret.append(pTriangulation.slice(i, i+3))
	
	return ret

#Reorders a polygon array so that it's start point is the one closest to pNearestStart
func ReorderPolygon(pPolygon:PackedVector2Array, pNearestStart:Vector2) -> PackedVector2Array:
	var ret:PackedVector2Array = []
	
	#Find the start point
	var nearestIndex:int = 0
	var nearestDistSquared:float = pPolygon[0].distance_squared_to(pNearestStart)
	var tempDistSquared:float = 0
	for i:int in range(1, pPolygon.size()):
		tempDistSquared = pPolygon[i].distance_squared_to(pNearestStart)
		if(tempDistSquared < nearestDistSquared):
			nearestIndex = i
			nearestDistSquared = tempDistSquared
	
	ret.append_array(pPolygon.slice(nearestIndex, pPolygon.size()))
	ret.append_array(pPolygon.slice(0, nearestIndex))
	
	return ret

#Returns the center point of a triangle
func GetCenterOfTriangle(pTriangle:PackedInt32Array, pData:PackedVector2Array) -> Vector2:
	var ret:Vector2
	ret.x = (pData[pTriangle[0]].x + pData[pTriangle[1]].x + pData[pTriangle[2]].x)/3
	ret.y = (pData[pTriangle[0]].y + pData[pTriangle[1]].y + pData[pTriangle[2]].y)/3
	return ret
