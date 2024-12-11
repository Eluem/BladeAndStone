extends MenuButton
class_name DropdownButton

signal selection_changing(pNewValue:int, pOldValue:int)

var popup:PopupMenu


var selectedOption:int:
	get:
		return selectedOption
	set(pValue):
		if(selectedOption != pValue):
			selection_changing.emit(pValue, selectedOption)
		selectedOption = pValue
		text = popup.get_item_text(popup.get_item_index(selectedOption))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	popup = get_popup()
	popup.id_pressed.connect(on_id_pressed)


func Initialize(pSelectedOption:int) -> void:
	selectedOption = pSelectedOption


func on_id_pressed(pID:int) -> void:
	selectedOption = pID
