extends Node2D
@onready var tile_map = $TileMap
@onready var canvas_layer = $CanvasLayer
const FACTORY_HUD = preload("res://scene/factory_hud/factory_hud.tscn")
const WAIT_HUD = preload("res://scene/wait_hud/wait_hud.tscn")

var prev_hover_cell: Vector2i = Vector2i.ZERO
var drag_start_pos: Vector2
var is_drag: bool = false

func _ready():
	create_level_factories()
	GameService.set_tilemap(tile_map)
	GameService.time.add_hours(7)
	var world_tile_size: Vector2i = tile_map.get_used_rect().size
	GameService.set_current_map_tile_size(world_tile_size)
	SignalsService.on_map_path_update.emit(tile_map.get_used_cells(Types.MAP_LAYERS.PATH))
	SignalsService.on_factory_click.connect(on_factory_click)
	SignalsService.on_factory_gui_close.connect(on_factory_gui_close)
	SignalsService.on_wait_hud_display.connect(on_wait_hud_display)
	SignalsService.on_wait_hud_close.connect(on_wait_hud_close)

func on_wait_hud_display(id: Vector2i, recipe: Types.Recipe):
	var hud = WAIT_HUD.instantiate()
	hud.poi_id = id
	hud.recipe = recipe
	canvas_layer.add_child(hud)

func on_factory_click(id: Vector2i):
	var hud = FACTORY_HUD.instantiate()
	hud.id = id
	canvas_layer.add_child(hud)

func on_wait_hud_close():
	var node = get_tree().get_first_node_in_group(GameService.GROUP_WAIT_HUD)
	if node == null:
		return
	node.call_deferred("queue_free")

func on_factory_gui_close(_id: Vector2i):
	var node = get_tree().get_first_node_in_group(GameService.GROUP_FACTORY_GUI)
	if node == null:
		return
	node.call_deferred("queue_free")

func _unhandled_input(event):
	handle_hover_cell(event)
	handle_click_cell(event)
	
func create_level_factories():
	var pois: Dictionary = {}
	pois[Vector2i(8,4)] = GameService.create_default_factory(Types.POI_TYPES.MARKET)
	pois[Vector2i(3,10)] = GameService.create_default_factory(Types.POI_TYPES.BAKERY)
	pois[Vector2i(12,10)] = GameService.create_default_factory(Types.POI_TYPES.LUMBERJACK)
	pois[Vector2i(28,6)] = GameService.create_default_factory(Types.POI_TYPES.ORCHARD)
	pois[Vector2i(25,13)] = GameService.create_default_factory(Types.POI_TYPES.WINDMILL)
	pois[Vector2i(11,16)] = GameService.create_default_factory(Types.POI_TYPES.FARM)
	pois[Vector2i(16,20)] = GameService.create_default_factory(Types.POI_TYPES.PORT)
	GameService.set_pois(pois)

func handle_click_cell(event):
	if !(event is InputEventMouseButton):
		return
	if event.button_index != MOUSE_BUTTON_LEFT:
		return
	if event.pressed:
		var clicked_cell = tile_map.local_to_map(get_global_mouse_position())
		
		var tile_data: TileData = tile_map.get_cell_tile_data(Types.MAP_LAYERS.PATH, clicked_cell)
		if tile_data != null and tile_data.get_custom_data("stable"):
			tile_map.set_cell(Types.MAP_LAYERS.HOVER, prev_hover_cell, 0, Vector2i(10,16))
			SignalsService.on_set_target.emit(clicked_cell)
			if GameService.get_horse_map_id() == clicked_cell:
				SignalsService.on_factory_click.emit(clicked_cell)
	elif not event.pressed:
		var clicked_cell = tile_map.local_to_map(get_global_mouse_position())
		var tile_data: TileData = tile_map.get_cell_tile_data(Types.MAP_LAYERS.PATH, clicked_cell)
		if tile_data != null and tile_data.get_custom_data("stable"):
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
		SignalsService.on_poi_hover.emit(Types.POI_TYPES.NONE)
	else:
		prev_hover_cell = hover_cell
		if tile_data.get_custom_data("stable") == true:
			tile_map.set_cell(Types.MAP_LAYERS.HOVER, prev_hover_cell, 0, Vector2i(9,16))
			SignalsService.on_poi_hover.emit(GameService.get_poi_by_id(hover_cell).type)
		else:	
			tile_map.set_cell(Types.MAP_LAYERS.HOVER, prev_hover_cell, 0, Vector2i(9,15))
			SignalsService.on_poi_hover.emit(Types.POI_TYPES.NONE)

func _on_timer_timeout():
	SignalsService.on_time_tick.emit()
