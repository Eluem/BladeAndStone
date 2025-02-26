#Collection of general functions to extend some functionality for GDScript
class_name GDScriptHelper

static func get_children_recursively(pNode:Node, pIncludeInternal:bool = false) -> Array[Node]:
	var ret:Array[Node] = pNode.get_children(pIncludeInternal)
	var i:int = 0
	while(i < ret.size()):
		ret.append_array(ret[i].get_children(pIncludeInternal))
		i+=1
	return ret
