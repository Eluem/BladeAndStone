extends PanelContainer
class_name RunSummary
@onready var scoreLabel:Label = $VBoxContainer/MarginContainer/GridContainer/ScoreLabel
@onready var scoreValue:Label = $VBoxContainer/MarginContainer/GridContainer/ScoreValue
@onready var timeValue:Label = $VBoxContainer/MarginContainer/GridContainer/TimeValue
@onready var damageDealtValue:Label = $VBoxContainer/MarginContainer/GridContainer/DamageDealtValue
@onready var damageTakenValue:Label = $VBoxContainer/MarginContainer/GridContainer/DamageTakenValue
@onready var enemiesShatteredValue:Label = $VBoxContainer/MarginContainer/GridContainer/EnemiesShatteredValue
@onready var newHighScore:Label = $VBoxContainer/NewHighScore

@onready var continueButton:Button = $ContinueButton

var isHighScore:bool = false
var highScoreColorStart:Color = Color.FLORAL_WHITE
var highScoreColorEnd:Color = Color.GOLD
var highScoreColorWeight:float = 0
var highScoreColorCycleSpeed:float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UpdateStatLabels()
	continueButton.pressed.connect(on_click_continue)

func _process(delta: float) -> void:
	if(isHighScore):
		HandleHighScoreFlashing(delta)


func UpdateStatLabels() -> void:
	isHighScore = StatTracker.CheckForHighScore()
	newHighScore.visible = isHighScore
	scoreValue.text = str(StatTracker.currentScore)
	timeValue.text = str(StatTracker.runTime)
	damageDealtValue.text = str(StatTracker.damageDealt)
	damageTakenValue.text = str(StatTracker.damageTaken)
	enemiesShatteredValue.text = str(StatTracker.enemiesShattered)

func HandleHighScoreFlashing(pDelta:float) -> void:
	highScoreColorWeight += highScoreColorCycleSpeed * pDelta
	var preclampWeight:float = highScoreColorWeight
	highScoreColorWeight = clampf(highScoreColorWeight, 0, 1)
	if(preclampWeight != highScoreColorWeight):
		highScoreColorCycleSpeed *= -1
	
	var newColor:Color = highScoreColorStart.lerp(highScoreColorEnd, highScoreColorWeight)
	
	scoreLabel.set("theme_override_colors/font_color", newColor)
	scoreValue.set("theme_override_colors/font_color", newColor)
	newHighScore.set("theme_override_colors/font_color", newColor)

func on_click_continue() -> void:
	GameStateManager.BeginFadeToScene(GameStateManager.SceneType.Credits)
