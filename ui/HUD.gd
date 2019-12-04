extends CanvasLayer


# Sets score label
func _ready():
	$MarginContainer/ScoreLabel.text = str(Global.score)


# Updates score label
func update_score(value):
	Global.score += value
	$MarginContainer/ScoreLabel.text = str(Global.score)
