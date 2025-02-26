@tool
extends VBoxContainer

@export var updateLabelSizes:bool:
	get():
		return updateLabelSizes
	set(pValue):
		if(pValue == true):
			UpdateLabelSizes()

func UpdateLabelSizes() -> void:
	var children:Array[Node] = GDScriptHelper.get_children_recursively(self)
	var labels:Array[Label] = []
	var largestWidth:float = 0
	for child:Node in children:
		if(child is Label && child is not SliderValueLabel):
			labels.append(child)
			if(labels[labels.size()-1].size.x > largestWidth):
				largestWidth = labels[labels.size()-1].size.x
	
	for labelChild:Label in labels:
		labelChild.custom_minimum_size.x = largestWidth
