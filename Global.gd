extends Node

var score
var levels = ['res://levels/Level1.tscn',
			  'res://levels/Level2.tscn']
var current_level

var start_screen = 'res://ui/StartScreen.tscn'
var end_screen = 'res://ui/EndScreen.tscn'


# Starts new game, starting back to the first level and resetting score
func new_game():
	score = 0
	current_level = -1
	next_level()


# Game over, loads end screen
func game_over():
	get_tree().change_scene(end_screen)


# Goes to next level
func next_level():
	current_level += 1
	
	# Checks if no more levels exist, game over if so
	if current_level >= Global.levels.size():
		game_over()
	else:
		get_tree().change_scene(levels[current_level])
