extends TileMap

@onready var player = $player

const HORSE_START_MAP_ID: Vector2i = Vector2i(4,4)

func _ready():
	create_level_pois()
	GameService.reset_level(7)
	GameService.load_tilemap(self, HORSE_START_MAP_ID)

func create_quest():
	var action: Callable = func ():
		SoundService.play(player, SoundService.SOUND_TYPE.WOOD_WORKING)
		var tilemap: TileMap = GameService.get_tilemap()
		tilemap.set_cell(Types.MAP_LAYERS.BUILDINGS, Vector2i(35, 10))
		tilemap.set_cell(Types.MAP_LAYERS.PATH, Vector2i(35, 10), 0, Vector2i(8,35))
		PathService.update_path(tilemap.get_used_cells(Types.MAP_LAYERS.PATH))
	return Quest.new(
		"The Bridge",
		"The bridge was destroyed in the storm, we can repair it, but we need some resources.",
		[InventoryItem.new(Types.ITEM.WOOD, 4), InventoryItem.new(Types.ITEM.BREAD, 1)],
		"Thank you for your help, the bridge is fixed.",
		action,
	)

func create_level_pois():
	var pois: Dictionary = {}
	pois[POI.id3(Vector2i(8,4))] = GameService.create_default_factory(Types.POI_TYPES.MARKET)
	pois[POI.id3(Vector2i(3,10))] = GameService.create_default_factory(Types.POI_TYPES.BAKERY)
	pois[POI.id3(Vector2i(12,10))] = GameService.create_default_factory(Types.POI_TYPES.LUMBERJACK)
	pois[POI.id3(Vector2i(28,6))] = GameService.create_default_factory(Types.POI_TYPES.ORCHARD)
	pois[POI.id3(Vector2i(25,13))] = GameService.create_default_factory(Types.POI_TYPES.WINDMILL)
	pois[POI.id3(Vector2i(11,16))] = GameService.create_default_factory(Types.POI_TYPES.FARM)
	pois[POI.id3(Vector2i(16,20))] = GameService.create_default_factory(Types.POI_TYPES.PORT)
	pois[POI.id3(Vector2i(32,9))] = create_quest()
	pois[POI.id3(Vector2i(41,10))] = Exit.new("The bridge is repaired. There is nothing left to do but hit the road.")
	GameService.set_pois(pois)
