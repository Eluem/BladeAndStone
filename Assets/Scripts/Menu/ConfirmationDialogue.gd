extends Control
class_name ConfirmationDialogue

signal dialogue_response(pResponse:bool)

@onready var closeButton:TextureButton = $PanelContainer/MarginContainer/VBoxContainer/Top/CloseButtonScaleEnabler/CloseButton
@onready var yesButton: Button = $PanelContainer/MarginContainer/VBoxContainer/ButtonContainer/YesButton
@onready var noButton: Button = $PanelContainer/MarginContainer/VBoxContainer/ButtonContainer/NoButton
@onready var promptLabel: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer/PromptLabel

func Initialize(pParent:Node, pCallback:Callable, pPromptText:String) -> void:
	pParent.add_child(self)
	owner = pParent
	dialogue_response.connect(pCallback)
	promptLabel.text = pPromptText


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	closeButton.pressed.connect(no_pressed)
	yesButton.pressed.connect(yes_pressed)
	noButton.pressed.connect(no_pressed)


func yes_pressed() -> void:
	dialogue_response.emit(true)
	queue_free()


func no_pressed() -> void:
	dialogue_response.emit(false)
	queue_free()
