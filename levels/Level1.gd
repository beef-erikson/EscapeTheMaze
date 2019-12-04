extends Node2D

export (PackedScene) var Enemy
export (PackedScene) var Pickup

# Caches Items map and creates array for doors
onready var items = $Items
var doors = []


# Sets map up and connects player / populates door array
func _ready():
	randomize()
	
	# Hides item layer
	$Items.hide()
	
	# Camera limits set so camera doesn't scroll past edges of map
	set_camera_limits()
	
	# Populates array of doors
	var door_id = $Walls.tile_set.find_tile_by_name('door_red')
	for cell in $Walls.get_used_cells_by_id(door_id):
		doors.append(cell)
	
	# Spawns items (obviously)
	spawn_items()
	
	# Connects all of the Player signals
	$Player.connect('dead', self, 'game_over')
	$Player.connect('grabbed_key', self, '_on_Player_grabbed_key')
	$Player.connect('win', self, '_on_Player_win')


# Limits the camera to the size of the map
func set_camera_limits():
	# Gets the ground layer of cells and size of each cell
	var map_size = $Ground.get_used_rect()
	var cell_size = $Ground.cell_size
	
	# Multiplies ground size by cell size gives total map in pixels to limit camera
	$Player/Camera2D.limit_left = map_size.position.x * cell_size.x
	$Player/Camera2D.limit_top = map_size.position.y * cell_size.y
	$Player/Camera2D.limit_right = map_size.end.x * cell_size.x
	$Player/Camera2D.limit_bottom = map_size.end.y * cell_size.y


# Handles spawning of items / enemies / player
func spawn_items():
	for cell in items.get_used_cells():
		# Gets id, type, and position of each item
		var id = items.get_cellv(cell)
		var type = items.tile_set.tile_get_name(id)
		var pos = items.map_to_world(cell) + items.cell_size / 2
		
		# Spawns enemies / player and sets properties for items (all by sprite name)
		match type:
			'slime_spawn':
				var s = Enemy.instance()
				s.position = pos
				s.tile_size = items.cell_size
				add_child(s)
			'player_spawn':
				$Player.position = pos
				$Player.tile_size = items.cell_size
			'coin', 'key_red', 'star':
				var p = Pickup.instance()
				p.init(type, pos)
				add_child(p)
				p.connect('coin_pickup', $HUD, 'update_score')


# Handles game over
func game_over():
	Global.game_over()


# Handles win condition (star was collected)
func _on_Player_win():
	Global.next_level()


# Key was collected, remove door tile(s)
func _on_Player_grabbed_key():
	for cell in doors:
		$Walls.set_cellv(cell, -1)
