extends Area2D

signal coin_pickup

var textures = {'coin': 'res://assets/coin.png',
				'key_red': 'res://assets/keyRed.png',
				'star': 'res://assets/star.png'}

# Used to determine what texture the object should use
var type


# Animates the scale and opacity of the item when picked up
func _ready():
	$Tween.interpolate_property($Sprite, 'scale', 
								Vector2(1, 1), Vector2(3, 3), 0.5, 
								Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Sprite, 'modulate',
								Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.5,
								Tween.TRANS_QUAD, Tween.EASE_IN_OUT)


# Initializations for sprite
func init(_type, pos):
	$Sprite.texture = load(textures[_type])
	type = _type
	position = pos


# Item picked up - adds 1 to score through emit, disabled collision, and starts tween
func pickup():
	match type:
		'coin':
			emit_signal('coin_pickup', 1)
	$CollisionShape2D.disabled = true
	$Tween.start()


# Tween finished running, delete item
func _on_Tween_tween_completed(object, key):
	queue_free()
