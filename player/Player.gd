extends "res://character/Character.gd"

signal moved
signal dead
signal grabbed_key
signal win


# Executes the move function based on key press and if the character is able to move
func _process(delta):
	if can_move:
		for dir in moves.keys():
			if Input.is_action_pressed(dir):
				if move(dir):
					emit_signal("moved")


# Emits signals based on if and what the player collides with
func _on_Player_area_entered(area):
	# Player hit enemy, player dead
	if area.is_in_group('enemies'):
		emit_signal('dead')
		
	# If an object has a pickup method, emit based on what is picked up
	if area.has_method('pickup'):
		area.pickup()
		if area.type == 'key_red':
			emit_signal('grabbed_key')
		if area.type == 'star':
			emit_signal('win')
