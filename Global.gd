extends Node

var score
var highscore = 0
var score_file = "user://highscore.txt"

var levels = ['res://levels/Level1.tscn',
			  'res://levels/Level2.tscn']
var current_level

var start_screen = 'res://ui/StartScreen.tscn'
var end_screen = 'res://ui/EndScreen.tscn'


# Runs setup on game start
func _ready():
	setup()


# Starts new game, starting back to the first level and resetting score
func new_game():
	score = 0
	current_level = -1
	next_level()


# Game over, checks score against highscore, updates if higher, and loads end screen 
func game_over():
	if score > highscore:
		highscore = score
		save_score()
	get_tree().change_scene(end_screen)


# Goes to next level
func next_level():
	current_level += 1
	
	# Checks if no more levels exist, game over if so
	if current_level >= Global.levels.size():
		game_over()
	else:
		get_tree().change_scene(levels[current_level])


# Reads in highscore if file exists
func setup():
	var f = File.new()
	if f.file_exists(score_file):
		f.open(score_file, File.READ)
		var content = f.get_as_text()
		highscore = int(content)
		f.close()


# Saves new high score
func save_score():
	var f = File.new()
	f.open(score_file, File.WRITE)
	f.store_string(str(highscore))
	f.close()
