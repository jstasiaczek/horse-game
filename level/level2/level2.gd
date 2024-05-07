extends Node2D
@onready var base_map = $BaseMap

const HORSE_START_MAP_ID: Vector2i = Vector2i(6,7)
func _ready():
	create_level_pois()
	GameService.reset_level(7)
	GameService.load_tilemap(base_map, HORSE_START_MAP_ID)

func create_level_pois():
	var pois: Dictionary = {}
	pois[POI.id3(Vector2i(15,9))] = Callback.new(func (): 
		SignalsService.on_set_horse_map_id.emit(Vector2i(26,12))
	)
	pois[POI.id3(Vector2i(26,11))] = Callback.new(func (): 
		SignalsService.on_set_horse_map_id.emit(Vector2i(15,10))
	)
	pois[POI.id3(Vector2i(9,9))] = Quest.new(
		"Test quest",
		"Jusc click finish...",
		[],
		"You made it!",
		func(): pass,
	)
	pois[POI.id3(Vector2i(31,12))] = Exit.new("You made it!")
	GameService.set_pois(pois)
