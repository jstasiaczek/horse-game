extends TileMap
const HORSE_START_MAP_ID: Vector2i = Vector2i(4,6)
func _ready():
	create_level_pois()
	GameService.time.clear()
	GameService.time.add_hours(7)
	GameService.clear_inventory()
	var world_tile_size: Vector2i = get_used_rect().size
	GameService.set_current_map_tile_size(world_tile_size)
	SignalsService.on_set_horse_map_id.emit(HORSE_START_MAP_ID)
	SignalsService.on_map_path_update.emit(get_used_cells(Types.MAP_LAYERS.PATH))

func create_level_pois():
	var pois: Dictionary = {}
	# add pois here
	GameService.set_pois(pois)
