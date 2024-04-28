extends TileMap

func _ready():
	create_level_pois()
	GameService.time.clear()
	GameService.time.add_hours(7)
	GameService.clear_inventory()
	var world_tile_size: Vector2i = get_used_rect().size
	GameService.set_current_map_tile_size(world_tile_size)
	SignalsService.on_set_horse_map_id.emit(Vector2i(4,6))
	SignalsService.on_map_path_update.emit(get_used_cells(Types.MAP_LAYERS.PATH))

func create_quest():
	var action: Callable = func ():
		var tilemap: TileMap = GameService.get_tilemap()
		tilemap.set_cell(Types.MAP_LAYERS.BUILDINGS, Vector2i(35, 10))
		tilemap.set_cell(Types.MAP_LAYERS.PATH, Vector2i(35, 10), 0, Vector2i(8,35))
		PathService.update_path(tilemap.get_used_cells(Types.MAP_LAYERS.PATH))
	return Types.new_quest(
		"The Bridge",
		"The bridge was destroyed in the storm, we can repair it, but we need some resources.",
		[Types.new_inventory_item(Types.ITEM.WOOD, 10), Types.new_inventory_item(Types.ITEM.BREAD, 1)],
		"Thank you for your help, the bridge is fixed.",
		action,
	)

func create_level_pois():
	var pois: Dictionary = {}
	pois[Vector2i(8,4)] = GameService.create_default_factory(Types.POI_TYPES.MARKET)
	pois[Vector2i(3,10)] = GameService.create_default_factory(Types.POI_TYPES.BAKERY)
	pois[Vector2i(12,10)] = GameService.create_default_factory(Types.POI_TYPES.LUMBERJACK)
	pois[Vector2i(28,6)] = GameService.create_default_factory(Types.POI_TYPES.ORCHARD)
	pois[Vector2i(25,13)] = GameService.create_default_factory(Types.POI_TYPES.WINDMILL)
	pois[Vector2i(11,16)] = GameService.create_default_factory(Types.POI_TYPES.FARM)
	pois[Vector2i(16,20)] = GameService.create_default_factory(Types.POI_TYPES.PORT)
	pois[Vector2i(32,9)] = create_quest()
	pois[Vector2i(41,10)] = Types.new_exit("The bridge is repaired. There is nothing left to do but hit the road.")
	GameService.set_pois(pois)
