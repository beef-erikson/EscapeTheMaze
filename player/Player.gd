extends "res://character/Character.gd"

signal moved
signal dead
signal grabbed_key
signal win


# Sets player scale back to normal (shrinks on death)
func _ready():
	$Sprite.scale = Vector2(1, 1)


# Executes the move function based on key press and if the character is able to move
func _process(delta):
	if can_move:
		for dir in moves.keys():
			if Input.is_action_pressed(dir):
				if move(dir):
					$Footsteps.play()
					emit_signal("moved")


# Emits signals based on if and what the player collides with
func _on_Player_area_entered(area):
	# Player hit enemy; hide enemy, stop processing, disable collision, and play death sound/anim
	if area.is_in_group('enemies'):
		area.hide()
		set_process(false)
		$CollisionShape2D.disabled = true
		$Lose.play()
		$AnimationPlayer.play('die')
		yield($AnimationPlayer, 'animation_finished')
		emit_signal('dead')
		
	# If an object has a pickup method, emit based on what is picked up
	if area.has_method('pickup'):
		area.pickup()
		if area.type == 'key_red':
			emit_signal('grabbed_key')
		# Level finished, plays sound and disables collision
		if area.type == 'star':
			$Win.play()
			$CollisionShape2D.disabled = true
			yield($Win, 'finished')
			emit_signal('win')
