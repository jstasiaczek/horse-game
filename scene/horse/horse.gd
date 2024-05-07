extends AnimatedSprite2D
@onready var horse_sound = $HorseSound

var horse_map_id: Vector2i
var tilemap: TileMap
var target: Vector2i = Vector2i.ZERO
var next_path_id: Vector2i = Vector2i.ZERO
var next_path_pos: Vector2 = Vector2.ZERO

func _ready():
	SignalsService.on_set_horse_map_id.connect(on_set_horse_map_id)
	SignalsService.on_tilemap_set.connect(on_tilemap_set)
	SignalsService.on_set_target.connect(on_set_target)
	SignalsService.on_horse_tile_changed.connect(on_horse_tile_changed)

func on_horse_tile_changed(id: Vector2i):
	if id != target:
		return
	var poi = GameService.get_poi_by_id(id)
	if poi == null:
		return
	SignalsService.on_poi_click.emit(id)


func on_set_horse_map_id(id: Vector2i):
	global_position = GameService.get_tilemap().map_to_local(id)
	update_horse_map_id()

func on_tilemap_set():
	tilemap = GameService.get_tilemap()
	update_horse_map_id()

func on_set_target(value: Vector2i):
	target = value

func update_horse_map_id():
	horse_map_id = tilemap.local_to_map(global_position)
	if horse_map_id == GameService.get_horse_map_id():
		return
	SignalsService.on_horse_tile_changed.emit(horse_map_id)

func has_horse_path() -> bool:
	return not PathService.get_id_path(horse_map_id, target).is_empty()

func get_horse_path() -> Array[Vector2i]:
	return PathService.get_id_path(horse_map_id, target).slice(1)

func _process(delta):
	if tilemap == null:
		return
	if not has_horse_path():
		horse_sound.stop()
		play("idile")
		tilemap.clear_layer(Types.MAP_LAYERS.NAVIGATE)
		return
	update_horse_map_id()
	var horse_pos: Vector2 = global_position
	var path: Array[Vector2i] = get_horse_path()
	if path.is_empty() and horse_pos == next_path_pos:
		play("idile")
		horse_sound.stop()
		tilemap.clear_layer(Types.MAP_LAYERS.NAVIGATE)
		return
	if horse_sound.playing == false:
		horse_sound.play()
	if not path.is_empty():
		tilemap.clear_layer(Types.MAP_LAYERS.NAVIGATE)
		for id in path:
			tilemap.set_cell(Types.MAP_LAYERS.NAVIGATE, id, 0, Vector2i(11,14))
		next_path_pos = tilemap.map_to_local(path[0])
		next_path_id = path[0]
		play_correct_horse_animation(horse_map_id -next_path_id)
	global_position = horse_pos.move_toward(next_path_pos, delta * 60)

func play_correct_horse_animation(delta: Vector2i):
	var new_animation: String = "idile"
	var new_flip_h: bool = flip_v
	if delta.x == -1:
		new_animation = "walk_right"
		new_flip_h = false
	elif delta.x == 1:
		new_animation = "walk_left"
		new_flip_h = true
	elif delta.y == 1:
		new_animation = "walk_up"
		new_flip_h = false
	elif delta.y == -1:
		new_animation = "walk_down"
		new_flip_h = false
	if new_animation == animation and new_flip_h == flip_h:
		return
	animation = new_animation
	flip_h = new_flip_h
