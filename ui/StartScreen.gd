extends Control


# Starts game when spacebar is hit
func _input(event):
	if event.is_action_pressed('ui_select'):
		Global.new_game()


# Displays high score
func _ready():
	$ScoreNotice.text = "High Score: " + str(Global.highscore)
