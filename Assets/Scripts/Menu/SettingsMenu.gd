extends Control
class_name SettingsMenu

signal settings_menu_response(pResponse:Dictionary)

const CONFIRMATION_DIALOGUE:PackedScene = preload("res://Assets/GameScenes/ConfirmationDialogue.tscn")

@onready var defaultButton:Button = $PanelContainer/BottomContainer/DefaultButton
@onready var saveCloseButton:Button = $PanelContainer/BottomContainer/SaveCloseButton
@onready var closeButton:Button = $PanelContainer/BottomContainer/CloseButton
@onready var musicVolumeSlider:HSlider = $PanelContainer/SettingsContainerOffsetter/SettingsOptionsContainer/MusicVolumeSlider
@onready var effectsVolumeSlider:HSlider = $PanelContainer/SettingsContainerOffsetter/SettingsOptionsContainer/EffectsVolumeSlider
@onready var invertInputCheck:CheckButton = $PanelContainer/SettingsContainerOffsetter/SettingsOptionsContainer/InvertInputCheck
@onready var checkButtonSliderGraphic:CheckButtonSliderGraphic = $PanelContainer/SettingsContainerOffsetter/SettingsOptionsContainer/InvertInputCheck/CheckButtonSliderGraphic

@onready var standardDefaultValues:Dictionary = GetValues()

var defaultValues:Dictionary


func Initialize(pParent:Node, pCallback:Callable, pCurrentValues:Dictionary = {}, pDefaultValues:Dictionary = {}) -> void:
	pParent.add_child(self)
	owner = pParent
	if(pDefaultValues.is_empty()):
		defaultValues = standardDefaultValues
	else:
		defaultValues = pDefaultValues.duplicate()
	SetValues(pCurrentValues)
	settings_menu_response.connect(pCallback)
	checkButtonSliderGraphic.ForceImmediateUpdate()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	defaultButton.pressed.connect(default_pressed)
	saveCloseButton.pressed.connect(save_close_pressed)
	closeButton.pressed.connect(close_pressed)
	
	if(defaultValues.is_empty()):
		defaultValues = standardDefaultValues

func GetValues() -> Dictionary:
	var ret:Dictionary = {
							"musicVolume":musicVolumeSlider.value
							,"sfxVolume":effectsVolumeSlider.value
							,"invertInputDirection":invertInputCheck.button_pressed
						 }
	return ret


func SetValues(pValues:Dictionary) -> void:
	if(pValues.has("musicVolume")):
		musicVolumeSlider.value = pValues.musicVolume
	if(pValues.has("sfxVolume")):
		effectsVolumeSlider.value = pValues.sfxVolume
	if(pValues.has("invertInputDirection")):
		invertInputCheck.button_pressed = pValues.invertInputDirection


func default_pressed() -> void:
	var confirmationDialogue:ConfirmationDialogue = CONFIRMATION_DIALOGUE.instantiate()
	confirmationDialogue.Initialize(self, default_dialogue_response, "Are you sure you want to reset all settings to their defaults?")


func save_close_pressed() -> void:
	settings_menu_response.emit(GetValues())
	queue_free()


func close_pressed() -> void:
	var confirmationDialogue:ConfirmationDialogue = CONFIRMATION_DIALOGUE.instantiate()
	confirmationDialogue.Initialize(self, close_dialogue_response, "Are you sure you want to close without saving your changes?")


func default_dialogue_response(pResponse:bool) -> void:
	if(!pResponse):
		return
	SetValues(defaultValues)


func close_dialogue_response(pResponse:bool) -> void:
	if(!pResponse):
		return
	queue_free()
