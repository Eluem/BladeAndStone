extends CanvasLayer

@onready var continueButton:Button = $ContinueButton
@onready var richTextLabel:RichTextLabel = $RichTextLabel

var timerEnableContinueButton:float
var timeToEnableContinueButton:float = 2
var timeToFullVisibilityContinueButton:float = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	continueButton.pressed.connect(on_click_continue)
	richTextLabel.meta_clicked.connect(meta_clicked)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timerEnableContinueButton += delta
	if(timerEnableContinueButton >= 2):
		continueButton.visible = true
		continueButton.modulate.a = move_toward(0, 1, (timerEnableContinueButton - timeToEnableContinueButton)/timeToFullVisibilityContinueButton)


func on_click_continue() -> void:
	GameStateManager.BeginFadeToScene(GameStateManager.SceneType.MainMenu)


func meta_clicked(pMeta:String) -> void:
	OS.shell_open(pMeta)
