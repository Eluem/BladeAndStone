@tool
extends Polygon2D
@export var generateInternalPolygons:bool
@export var generateVertexColors:bool
@export var resetToDefaultPolgyon:bool
@export var ringScaling:Array[float] #number of rings determined by size of array
@export var colorPerRing:Array[Color] #this includes the outer ring, length should be ringScaling.Size() + 1


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
	vertex_colors = []
	for i in range(0, 39):
		newVertexColors.append(colorPerRing[0])
	for i in range(39, polygon.size()):
		newVertexColors.append(colorPerRing[3])
	vertex_colors = newVertexColors

func ClearInternalData() -> void:
	var newPolygonData:PackedVector2Array = []
	newPolygonData = polygon.slice(0, polygon.size() - internal_vertex_count)
	polygons = []
	internal_vertex_count = 0
	polygon = newPolygonData

func ResetToDefaultPolgyon() -> void:
	ClearInternalData()
	vertex_colors = []
	
func GetPolygons(pTriangulation:PackedInt32Array) -> Array[PackedInt32Array]:
	print(pTriangulation)
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
