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
var currValues:Dictionary
var prevSliderValue:float


func Initialize(pParent:Node, pCallback:Callable, pCurrValues:Dictionary = {}, pDefaultValues:Dictionary = {}) -> void:
	pParent.add_child(self)
	owner = pParent
	currValues = pCurrValues
	if(pDefaultValues.is_empty()):
		defaultValues = standardDefaultValues
	else:
		defaultValues = pDefaultValues.duplicate()
	SetValues(pCurrValues)
	settings_menu_response.connect(pCallback)
	checkButtonSliderGraphic.ForceImmediateUpdate()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	defaultButton.pressed.connect(default_pressed)
	saveCloseButton.pressed.connect(save_close_pressed)
	closeButton.pressed.connect(close_pressed)
	invertInputCheck.pressed.connect(toggle_pressed_SFX)
	musicVolumeSlider.drag_started.connect(slider_drag_started_SFX.bind(musicVolumeSlider))
	musicVolumeSlider.drag_ended.connect(slider_drag_ended_SFX)
	musicVolumeSlider.value_changed.connect(slider_value_changed_SFX)
	effectsVolumeSlider.drag_started.connect(slider_drag_started_SFX.bind(effectsVolumeSlider))
	effectsVolumeSlider.drag_ended.connect(slider_drag_ended_SFX)
	effectsVolumeSlider.value_changed.connect(slider_value_changed_SFX)
	
	if(defaultValues.is_empty()):
		defaultValues = standardDefaultValues


func _input(event:InputEvent) -> void:
	if(!visible):
		return
	if(event.is_action_pressed("ui_cancel")):
		get_viewport().set_input_as_handled()
		close_pressed()


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

func IsDataChanged() -> bool:
	var ret:bool = false
	var newValues:Dictionary = GetValues()
	for key:String in newValues.keys():
		if(newValues[key] != currValues[key]):
			ret = true
	return ret


func default_pressed() -> void:
	(CanvasManagerScene as CanvasManager).buttonPressSFX.play()
	var confirmationDialogue:ConfirmationDialogue = CONFIRMATION_DIALOGUE.instantiate()
	confirmationDialogue.Initialize(self, default_dialogue_response, "Are you sure you want to reset all settings to their defaults?")


func save_close_pressed() -> void:
	(CanvasManagerScene as CanvasManager).buttonPressSFX.play()
	settings_menu_response.emit(GetValues())
	queue_free()


func close_pressed() -> void:
	(CanvasManagerScene as CanvasManager).buttonPressSFX.play()
	if(IsDataChanged()):
		var confirmationDialogue:ConfirmationDialogue = CONFIRMATION_DIALOGUE.instantiate()
		confirmationDialogue.Initialize(self, close_dialogue_response, "Are you sure you want to close without saving your changes?")
	else:
		close_dialogue_response(true)


func toggle_pressed_SFX() -> void:
	(CanvasManagerScene as CanvasManager).togglePressSFX.play()


func slider_drag_started_SFX(pSlider:Slider) -> void:
	(CanvasManagerScene as CanvasManager).buttonPressSFX.play()
	prevSliderValue = pSlider.value


func slider_drag_ended_SFX(_pValueChanged:bool) -> void:
	(CanvasManagerScene as CanvasManager).buttonPressSFX.play()


func slider_value_changed_SFX(pValue:float) -> void:
	if((CanvasManagerScene as CanvasManager).sliderDragSFX.playing):
		return
	if(int(prevSliderValue / 0.05) != int(pValue / 0.05) || (prevSliderValue > 0 and pValue <= 0)):
		(CanvasManagerScene as CanvasManager).sliderDragSFX.play()
	prevSliderValue = pValue


func default_dialogue_response(pResponse:bool) -> void:
	if(!pResponse):
		return
	SetValues(defaultValues)


func close_dialogue_response(pResponse:bool) -> void:
	if(!pResponse):
		return
	queue_free()
