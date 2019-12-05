extends Area2D

# Movement and animation speed of the character
export (int) var speed

var tile_size = 64

# Flag to check if character can move
var can_move = true

# Current direction of movement
var facing = 'right'

# Describes the 4 cardinal direction in Vector form
var moves = {'right': Vector2(1, 0),
			 'left': Vector2(-1, 0),
			 'up': Vector2(0, -1),
			 'down': Vector2(0, 1)}

# Refers the 4 raycast nodes to a direction 
# (onready is used to ensure var isn't set before the referenced node is ready)
onready var raycasts = {'right': $RayCastRight,
						'left': $RayCastLeft,
						'up': $RayCastUp,
						'down': $RayCastDown}


# Moves via grid-based movement
func move(dir):
	# Sets animation speed and facing direction
	$AnimationPlayer.playback_speed = speed
	facing = dir
	
	# Checks for collisions
	if raycasts[facing].is_colliding():
		return
	
	# Makes player unable to move a second time and plays movement animation
	can_move = false
	$AnimationPlayer.play(facing)
	
	# Moves a full tile and uses a sine transition for a smooth movement speed
	$MoveTween.interpolate_property(self, "position", position,
				position + moves[facing] * tile_size,
				1.0 / speed, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$MoveTween.start()
	return true


# Tween finished - can now move again
func _on_MoveTween_tween_completed(object, key):
	can_move = true
