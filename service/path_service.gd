extends Node

var _path_service: AStarGrid2D = AStarGrid2D.new()
var _current_path_set: Array[Vector2i] = []
var _current_region: Rect2i

func _init():
	_path_service.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_path_service.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_path_service.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	
	SignalsService.on_map_tile_size_update.connect(_on_map_tile_size_update)
	SignalsService.on_map_path_update.connect(_on_map_path_update)

func _on_map_path_update(value: Array[Vector2i]):
	_current_path_set = value
	_set_all_region_solid()
	_set_path_ids()


func update_path(value: Array[Vector2i]):
	_set_all_region_solid()
	_current_path_set = value
	_set_path_ids()

func _on_map_tile_size_update(value: Vector2i):
	var region: Rect2i = Rect2i(Vector2i(0,0), value)
	_current_region = region
	_path_service.region = region
	_path_service.update()
	_set_all_region_solid()
	_set_path_ids()

func get_id_path(from_id: Vector2i, to_id: Vector2i) -> Array[Vector2i]:
	return _path_service.get_id_path(from_id, to_id)

func _set_path_ids():
	for tile in _current_path_set:
		_path_service.set_point_solid(tile, false)

func _set_all_region_solid():
	if _current_region != null:
		_path_service.fill_solid_region(_current_region, true)
