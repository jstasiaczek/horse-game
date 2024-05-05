extends TileMap
const HORSE_START_MAP_ID: Vector2i = Vector2i(4,6)
func _ready():
	create_level_pois()
	GameService.reset_level(7)
	GameService.load_tilemap(self, HORSE_START_MAP_ID)

func create_level_pois():
	var pois: Dictionary = {}
	# add pois here
	GameService.set_pois(pois)
