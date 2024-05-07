extends Node2D

const FACTORY_HUD = preload("res://scene/factory_hud/factory_hud.tscn")
const QUEST_HUD = preload("res://scene/quest_hud/quest_hud.tscn")
const EXIT_HUD = preload("res://scene/exit_hud/exit_hud.tscn")
const WAIT_HUD = preload("res://scene/wait_hud/wait_hud.tscn")
const LEVEL_DEFAULT = preload("res://level/level_default/level_default.tscn")

@onready var canvas_layer = $CanvasLayer
@onready var tile_map_container = $TileMapContainer
@onready var horse = $Horse

var tile_map: TileMap
var prev_hover_cell: Vector2i = Vector2i.ZERO
var drag_start_pos: Vector2

func load_level():
	var level
	if GameService.get_level_path() == "":
		level = LEVEL_DEFAULT.instantiate()
	else:
		level = load(GameService.get_level_path()).instantiate()
	tile_map_container.add_child(level)

func _ready():
	SignalsService.on_tilemap_set.connect(on_tilemap_set)
	SignalsService.on_poi_click.connect(on_poi_click)
	SignalsService.on_factory_gui_close.connect(on_factory_gui_close)
	SignalsService.on_wait_hud_display.connect(on_wait_hud_display)
	SignalsService.on_wait_hud_close.connect(on_wait_hud_close)
	SignalsService.on_quest_gui_close.connect(on_quest_gui_close)
	SignalsService.on_exit_gui_close.connect(on_exit_gui_close)
	load_level()

func on_tilemap_set():
	tile_map = GameService.get_tilemap()
	SignalsService.on_start_fade_out.emit()


func on_wait_hud_display(id: Vector2i, recipe: Recipe):
	var hud = WAIT_HUD.instantiate()
	hud.poi_id = id
	hud.recipe = recipe
	canvas_layer.add_child(hud)

func on_poi_click(id: Vector2i):
	var poi = GameService.get_poi_by_id(id)
	if poi == null:
		return
	match poi.action_type:
		Types.POI_GROUP_TYPE.FACTORY:
			var hud = FACTORY_HUD.instantiate()
			hud.id = id
			canvas_layer.add_child(hud)
		Types.POI_GROUP_TYPE.QUEST:
			var hud = QUEST_HUD.instantiate()
			hud.id = id
			hud.quest = poi
			canvas_layer.add_child(hud)
		Types.POI_GROUP_TYPE.EXIT:
			var hud = EXIT_HUD.instantiate()
			hud.id = id
			hud.exit = poi
			canvas_layer.add_child(hud)
		Types.POI_GROUP_TYPE.CALLBACK:
			poi.callback.call()

func on_exit_gui_close(_id: Vector2i):
	close_gui_by_group(GameService.GROUP_EXIT_HUD)

func on_quest_gui_close(_id: Vector2i):
	close_gui_by_group(GameService.GROUP_QUEST_HUD)

func on_wait_hud_close():
	close_gui_by_group(GameService.GROUP_WAIT_HUD)

func on_factory_gui_close(_id: Vector2i):
	close_gui_by_group(GameService.GROUP_FACTORY_GUI)

func close_gui_by_group(group: String):
	var node = get_tree().get_first_node_in_group(group)
	if node == null:
		return
	node.call_deferred("queue_free")

func _unhandled_input(event):
	handle_hover_cell(event)
	handle_click_cell(event)

func handle_click_cell(event):
	if !(event is InputEventMouseButton):
		return
	if event.button_index != MOUSE_BUTTON_LEFT:
		return
	if event.pressed:
		var clicked_cell = tile_map.local_to_map(get_global_mouse_position())
		var tile_data: TileData = tile_map.get_cell_tile_data(Types.MAP_LAYERS.PATH, clicked_cell)
		if tile_data != null and tile_data.get_custom_data(GameService.MAP_CUSTOM_DATA_HORSE_STOP):
			tile_map.set_cell(Types.MAP_LAYERS.HOVER, prev_hover_cell, 0, Vector2i(10,16))
			SignalsService.on_set_target.emit(clicked_cell)
			if GameService.get_horse_map_id() == clicked_cell:
				SignalsService.on_poi_click.emit(clicked_cell)
	elif not event.pressed:
		var clicked_cell = tile_map.local_to_map(get_global_mouse_position())
		var tile_data: TileData = tile_map.get_cell_tile_data(Types.MAP_LAYERS.PATH, clicked_cell)
		if tile_data != null and tile_data.get_custom_data(GameService.MAP_CUSTOM_DATA_HORSE_STOP):
			tile_map.set_cell(Types.MAP_LAYERS.HOVER, prev_hover_cell, 0, Vector2i(9,16))

func handle_hover_cell(event):
	if !(event is InputEventMouseMotion):
		return
	var hover_cell = tile_map.local_to_map(get_global_mouse_position())
	if hover_cell == prev_hover_cell:
		return
	tile_map.set_cell(Types.MAP_LAYERS.HOVER, prev_hover_cell, 0)
	var tile_data: TileData = tile_map.get_cell_tile_data(Types.MAP_LAYERS.PATH, hover_cell)
	if tile_data == null:
		prev_hover_cell = Vector2i.ZERO
		SignalsService.on_poi_hover.emit(Types.POI_TYPES.NONE, hover_cell)
	else:
		prev_hover_cell = hover_cell
		if tile_data.get_custom_data(GameService.MAP_CUSTOM_DATA_HORSE_STOP) == true:
			tile_map.set_cell(Types.MAP_LAYERS.HOVER, prev_hover_cell, 0, Vector2i(9,16))
			var poi = GameService.get_poi_by_id(hover_cell)
			if poi != null:
				SignalsService.on_poi_hover.emit(poi.type, hover_cell)
		else:
			tile_map.set_cell(Types.MAP_LAYERS.HOVER, prev_hover_cell, 0, Vector2i(9,15))
			SignalsService.on_poi_hover.emit(Types.POI_TYPES.NONE, hover_cell)

func _on_timer_timeout():
	SignalsService.on_time_tick.emit()
