extends "res://character/Character.gd"


# Uses a one-off timer in order to wait for tiles in tilemap to load completely before moving
func _ready():
	can_move = false
	facing = moves.keys()[randi() % 4]
	yield(get_tree().create_timer(0.5), 'timeout')
	can_move = true


# If able, the enemy will move every frame, avoiding walls and randomly changing direction
# (alternately, this could be _on_Player_moved() and connected to player's moved signal,
#  which would make the enemy move only when the player does)
func _process(delta):
	if can_move:
		if not move(facing) or randi() % 10 > 5:
			facing = moves.keys()[randi() % 4]
