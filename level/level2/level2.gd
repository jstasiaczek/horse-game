extends Node2D
@onready var base_map = $BaseMap
@onready var underground_map = $Underground/UndergroundMap
@onready var underground = $Underground

const UNDERGROUND_MAP_ID: int = 1

const HORSE_START_MAP_ID: Vector2i = Vector2i(7,6)

func _ready():
	create_level_pois()
	switch_map(true)
	GameService.reset_level(7)
	GameService.set_current_level_map_id(UNDERGROUND_MAP_ID)
	GameService.load_tilemap(underground_map, HORSE_START_MAP_ID, true)

func switch_map(is_underground: bool = false):
	base_map.visible = not is_underground
	underground.visible = is_underground

func create_level_pois():
	var pois: Dictionary = {}
	create_passages(pois)
	create_quests(pois)
	create_factory(pois)
	#exit
	pois[POI.id3(Vector2i(31,12))] = Exit.new("You made it!")
	GameService.set_pois(pois)

func create_factory(pois: Dictionary):
	# mine
	pois[POI.id3(Vector2i(9,5), UNDERGROUND_MAP_ID)] = Factory.new(
		Types.POI_TYPES.MINE,
		[
			Recipe.new(
				[Types.ITEM.COIN],
				Types.ITEM.IRON,
				1,
				30,
			)
		]
	)
	# market
	pois[POI.id3(Vector2i(4,9))] = Factory.new(
		Types.POI_TYPES.MARKET,
		[
			Recipe.new(
				[Types.ITEM.FLOUR],
				Types.ITEM.COIN,
				2,
				0,
			),
			Recipe.new(
				[Types.ITEM.WHEAT],
				Types.ITEM.COIN,
				1,
				0,
			),
			Recipe.new(
				[Types.ITEM.IRON],
				Types.ITEM.COIN,
				4,
				0,
			),
			Recipe.new(
				[Types.ITEM.COIN, Types.ITEM.FLOUR],
				Types.ITEM.BREAD,
				1,
				0,
			),
		]
	)
	# farm
	var farm: Factory = GameService.create_default_factory(Types.POI_TYPES.FARM)
	farm.recipes.append(Recipe.new([], Types.ITEM.WHEAT, 1, 4 * 60, true))
	pois[POI.id3(Vector2i(10,5))] = farm
	pois[POI.id3(Vector2i(14,14))] = GameService.create_default_factory(Types.POI_TYPES.WINDMILL)
	pois[POI.id3(Vector2i(17,6))] = Factory.new(
		Types.POI_TYPES.BLACKSMITH,
		[
			Recipe.new(
				[Types.ITEM.IRON, Types.ITEM.COIN],
				Types.ITEM.PICKAXE,
				1,
				60,
			),
		]
	)
	pois[POI.id3(Vector2i(24,3))] = Factory.new(
		Types.POI_TYPES.ALCHEMIST,
		[
			Recipe.new(
				[Types.ITEM.COIN],
				Types.ITEM.TNT,
				1,
				60,
			),
		]
	)

func create_quests(pois: Dictionary):
	pois[POI.id3(Vector2i(35,17), UNDERGROUND_MAP_ID)] = Quest.new(
		"Boom!",
		"To unlock this passage, I will need explosives. There is an alchemist living behind the mountains, you can get there through the second passage.",
		[InventoryItem.new(Types.ITEM.TNT, 1)],
		"It worked, the road is clear.",
		func ():
			var tilemap: TileMap = GameService.get_tilemap()
			tilemap.set_cell(Types.MAP_LAYERS.BUILDINGS, Vector2i(38, 16))
			tilemap.set_cell(Types.MAP_LAYERS.BUILDINGS, Vector2i(39, 16))
			tilemap.set_cell(Types.MAP_LAYERS.PATH, Vector2i(37, 16), 0, Vector2i(2,52))
			tilemap.set_cell(Types.MAP_LAYERS.PATH, Vector2i(38, 16), 0, Vector2i(2,52))
			tilemap.set_cell(Types.MAP_LAYERS.PATH, Vector2i(39, 16), 0, Vector2i(2,52))
			tilemap.set_cell(Types.MAP_LAYERS.PATH, Vector2i(40, 16), 0, Vector2i(2,52))
			PathService.update_path(tilemap.get_used_cells(Types.MAP_LAYERS.PATH))
	)
	
	pois[POI.id3(Vector2i(36,14), UNDERGROUND_MAP_ID)] = Quest.new(
		"Tools!",
		"The obstacle is small, all I need is a pickaxe, unfortunately mine is damaged. Bring me a new one and I'll clear the passage.",
		[InventoryItem.new(Types.ITEM.PICKAXE, 1)],
		"It was hard work, the road is clear.",
		func ():
			var tilemap: TileMap = GameService.get_tilemap()
			tilemap.set_cell(Types.MAP_LAYERS.BUILDINGS, Vector2i(35, 12))
			tilemap.set_cell(Types.MAP_LAYERS.PATH, Vector2i(35, 13), 0, Vector2i(3,52))
			tilemap.set_cell(Types.MAP_LAYERS.PATH, Vector2i(35, 12), 0, Vector2i(3,52))
			tilemap.set_cell(Types.MAP_LAYERS.PATH, Vector2i(35, 11), 0, Vector2i(5,52))
			PathService.update_path(tilemap.get_used_cells(Types.MAP_LAYERS.PATH))
	)

func create_passages(pois: Dictionary):
	# exit enterance passage
	pois[POI.id3(Vector2i(22,3), UNDERGROUND_MAP_ID)] = Callback.new(func ():
		switch_map()
		GameService.change_level_map(base_map, Vector2i(6,7), GameService.DEFAULT_LEVEL_MAP_ID)
	)
	# return to enterance passage
	pois[POI.id3(Vector2i(5,7))] = Callback.new(func ():
		switch_map(true)
		GameService.change_level_map(underground_map, Vector2i(22,4), UNDERGROUND_MAP_ID, true)
	)
	# undermountain passage enterance
	pois[POI.id3(Vector2i(19,10))] = Callback.new(func ():
		switch_map(true)
		GameService.change_level_map(underground_map, Vector2i(28,16), UNDERGROUND_MAP_ID, true)
	)
	# undermountain passage exit - main land
	pois[POI.id3(Vector2i(27,16), UNDERGROUND_MAP_ID)] = Callback.new(func ():
		switch_map()
		GameService.change_level_map(base_map, Vector2i(18,10), GameService.DEFAULT_LEVEL_MAP_ID)
	)

	# undermountain passage exit - alchemy
	pois[POI.id3(Vector2i(39,11), UNDERGROUND_MAP_ID)] = Callback.new(func ():
		switch_map()
		GameService.change_level_map(base_map, Vector2i(23,5), GameService.DEFAULT_LEVEL_MAP_ID)
	)

	# undermountain passage enter - alchemy
	pois[POI.id3(Vector2i(22,5))] = Callback.new(func ():
		switch_map(true)
		GameService.change_level_map(underground_map, Vector2i(38,11), UNDERGROUND_MAP_ID, true)
	)

	# undermountain passage exit - port
	pois[POI.id3(Vector2i(44,16), UNDERGROUND_MAP_ID)] = Callback.new(func ():
		switch_map()
		GameService.change_level_map(base_map, Vector2i(24,11), GameService.DEFAULT_LEVEL_MAP_ID)
	)

	# undermountain passage enter - port
	pois[POI.id3(Vector2i(23,11))] = Callback.new(func ():
		switch_map(true)
		GameService.change_level_map(underground_map, Vector2i(43,16), UNDERGROUND_MAP_ID, true)
	)
