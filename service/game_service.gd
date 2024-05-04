extends Node

const SCENE_MAP = preload("res://scene/map/map.tscn")
const SCENE_LEVEL_SELECTION = preload("res://scene/level_selection_gui/level_selection_gui.tscn")

const MAX_ZOOM: float = 2.0
const MIN_ZOOM: float = 1.5
const MINUTES_ADD_ON_TICK: int = 10
const GROUP_FACTORY_GUI: String = "FACTORY_GUI"
const GROUP_WAIT_HUD = "WAIT_HUD"
const GROUP_QUEST_HUD = "QUEST_HUD"
const GROUP_EXIT_HUD = "EXIT_HUD"
const HORSE_TIRED_COOLDOWN: int = 60 * 4

var _tile_size: Vector2i = Vector2i(16,16)
var _current_map_tile_size: Vector2i
var _tilemap_instance: TileMap
var MAP_PADDING: int = 64
var time: GameTime = GameTime.new()
var _pois: Dictionary = {}
var _horse_map_id: Vector2i
var _horse_inventory: Array[Types.InventoryItem] = []
var _horse_tired: int = 0
var _level_path: String = ""

class GameTime:
	var minutes: int = 0
	func clear():
		minutes = 0
	func set_minutes(value: int):
		minutes = value
		SignalsService.on_time_changed.emit()
	func add_minutes(value: int):
		set_minutes(minutes + value)
	func add_hours(value: int):
		add_minutes(value * 60) 
	func add_day(value: int):
		add_hours(24 * value)
	func get_minutes() -> int:
		return minutes
	func get_minute() -> int:
		return minutes % 60
	func get_hour() -> int:
		return (minutes / 60) % 24
	func get_day() -> int:
		return (minutes / 60) / 24
	func get_day_string():
		if get_day() == 1:
			return "day"
		return "days"
	func format():
		return "%4d %s %02d:%02d" % [get_day(), get_day_string(), get_hour(), get_minute()]

func _ready():
	SignalsService.on_time_tick.connect(on_time_tick)
	SignalsService.on_time_changed.connect(on_time_changed)
	SignalsService.on_horse_tile_changed.connect(on_horse_tile_changed)

func on_time_tick():
	time.add_minutes(MINUTES_ADD_ON_TICK)

func on_time_changed():
	for poi_id in _pois.keys():
		var poi = _pois[poi_id]
		if poi.action_type == Types.POI_ACTON_TYPE.FACTORY and poi.has_doable_queue():
			poi.add_time(MINUTES_ADD_ON_TICK)
			if poi.process():
				SignalsService.on_factory_output_update.emit(poi_id)
				SignalsService.on_factory_queue_update.emit(poi_id)
	if is_horse_tired():
		_horse_tired -= MINUTES_ADD_ON_TICK
		if is_horse_tired() == false:
			clear_horse_tired()
			SignalsService.on_horse_rested.emit()

########## LEVEL FUNCTIONS ###############
func load_level_select():
	get_tree().change_scene_to_packed(SCENE_LEVEL_SELECTION)

func load_map(level: String):
	set_level_path(level)
	get_tree().change_scene_to_packed(SCENE_MAP)

func set_level_path(value: String):
	_level_path = value

func get_level_path() -> String:
	return _level_path

########## HORSE FUNCTIONS ##############

func is_horse_tired() -> bool:
	return _horse_tired > 0

func set_horse_tired():
	_horse_tired = HORSE_TIRED_COOLDOWN
	SignalsService.on_horse_tired.emit()

func clear_horse_tired():
	_horse_tired = 0

########### INVENTORY FUNCTIONS ###############

func get_inventory() -> Array[Types.InventoryItem]:
	return _horse_inventory

func clear_inventory():
	_horse_inventory = InventoryTool.get_empty()

func can_pay_for_recipe(recipe: Types.Recipe) -> bool:
	return InventoryTool.can_pay_for_recipe(_horse_inventory, recipe)

func pay_for_recipe(recipe: Types.Recipe) -> bool:
	if can_pay_for_recipe(recipe) == false:
		return false
	_horse_inventory = InventoryTool.pay_for_recipe(_horse_inventory, recipe)
	SignalsService.on_inventory_update.emit()
	return true

func remove_from_inventory(item: Types.ITEM, count: int = 1):
	if not has_in_inventory(item, count):
		return
	_horse_inventory = InventoryTool.remove_from_inventory(_horse_inventory, item, count)
	print("remove")
	SignalsService.on_inventory_update.emit()

func has_in_inventory(item: Types.ITEM, count: int = 1) -> bool:
	return InventoryTool.has_in_inventory(_horse_inventory, item, count)

func add_to_inventory(item: Types.ITEM, count: int = 1):
	_horse_inventory = InventoryTool.add_to_inventory(_horse_inventory, item, count)
	SignalsService.on_inventory_update.emit()

########### TILEMAP FUNCTIONS ##################

func set_current_map_tile_size(value: Vector2i):
	_current_map_tile_size = value
	SignalsService.on_map_tile_size_update.emit(value)

func get_map_width_px() -> int:
	return _current_map_tile_size.x * _tile_size.x
	
func get_map_height_px() -> int:
	return _current_map_tile_size.y * _tile_size.y

func set_tilemap(value: TileMap):
	_tilemap_instance = value
	SignalsService.on_tilemap_set.emit()
	
func get_tilemap() -> TileMap:
	return _tilemap_instance

################# POI FUNCTIONS #####################
func set_pois(value: Dictionary):
	_pois = value
	
func get_pois() -> Dictionary:
	return _pois

func get_poi_by_id(id: Vector2i):
	if _pois.has(id):
		return _pois[id]
	return null

func on_horse_tile_changed(id: Vector2i):
	_horse_map_id = id

func get_horse_map_id() -> Vector2i:
	return _horse_map_id

############ FACTORY FUNCTIONS ############
func add_recipe_to_queue(id: Vector2i, recipe: Types.Recipe):
	var poi = get_poi_by_id(id)
	if poi == null or poi.action_type != Types.POI_ACTON_TYPE.FACTORY:
		return
	poi.recipe_queue.append(recipe)
	SignalsService.on_factory_queue_update.emit(id)

func add_item_to_output(id: Vector2i, recipe: Types.Recipe):
	var poi = get_poi_by_id(id)
	if poi == null or poi.action_type != Types.POI_ACTON_TYPE.FACTORY:
		return
	for i in range(recipe.output.count):
		poi.output.append(recipe.output.item)
	SignalsService.on_factory_output_update.emit(id)

func clear_factory_output(id: Vector2i):
	var poi = get_poi_by_id(id)
	if poi == null or poi.action_type != Types.POI_ACTON_TYPE.FACTORY:
		return
	poi.output.clear()
	SignalsService.on_factory_output_update.emit(id)

func create_default_factory(type: Types.POI_TYPES):
	var recipes: Array[Types.Recipe] = []
	match type:
		Types.POI_TYPES.BAKERY:
			recipes.append(Types.new_recipe([Types.ITEM.FLOUR], Types.ITEM.BREAD, 1, 15))
			return Types.new_factory(type, recipes)
		Types.POI_TYPES.FARM:
			recipes.append(Types.new_recipe([Types.ITEM.COIN], Types.ITEM.WHEAT, 1, 60))
			return Types.new_factory(type, recipes)
		Types.POI_TYPES.LUMBERJACK:
			recipes.append(Types.new_recipe([Types.ITEM.COIN, Types.ITEM.BREAD], Types.ITEM.WOOD, 1, 15))
			return Types.new_factory(type, recipes)
		Types.POI_TYPES.ORCHARD:
			recipes.append(Types.new_recipe([], Types.ITEM.APPLE, 1, 60*4, true))
			recipes.append(Types.new_recipe([Types.ITEM.COIN], Types.ITEM.APPLE, 1, 15))
			return Types.new_factory(type, recipes)
		Types.POI_TYPES.WINDMILL:
			recipes.append(Types.new_recipe([Types.ITEM.WHEAT], Types.ITEM.FLOUR, 1, 30))
			return Types.new_factory(type, recipes)
		Types.POI_TYPES.PORT:
			recipes.append(Types.new_recipe([Types.ITEM.COIN], Types.ITEM.FISH, 1, 60))
			return Types.new_factory(type, recipes)
		Types.POI_TYPES.MARKET:
			recipes.append(Types.new_recipe([Types.ITEM.FISH], Types.ITEM.COIN, 2, 0))
			recipes.append(Types.new_recipe([Types.ITEM.WOOD], Types.ITEM.COIN, 6, 0))
			recipes.append(Types.new_recipe([Types.ITEM.APPLE], Types.ITEM.COIN, 1, 0))
			recipes.append(Types.new_recipe([Types.ITEM.BREAD], Types.ITEM.COIN, 4, 0))
			return Types.new_factory(type, recipes)
	return null
