extends TileMap

const HORSE_START_MAP_ID: Vector2i = Vector2i(4,6)
const MOUSE_LEFT_ICON_CODE: String = "[img]res://assets/icons/mouse_left.png[/img]"
const MOUSE_MIDDLE_ICON_CODE: String = "[img]res://assets/icons/mouse_middle.png[/img]"
const MOUSE_RIGHT_ICON_CODE: String = "[img]res://assets/icons/mouse_right.png[/img]"
const STOP_EXIT_CODE: String = "[img]res://assets/icons/stop-exit.png[/img]"
const STOP_FACTORY_CODE: String = "[img]res://assets/icons/stop-factory.png[/img]"
const STOP_QUEST_CODE: String = "[img]res://assets/icons/stop-quest.png[/img]"

@onready var marker_1 = $Markers/Marker1
@onready var marker_2 = $Markers/Marker2
@onready var marker_3 = $Markers/Marker3
@onready var player = $player
@onready var explosion = $explosion

func _ready():
	create_level_pois()
	GameService.reset_level(7)
	GameService.load_tilemap(self, HORSE_START_MAP_ID)
	explosion.visible = false

func create_level_pois():
	var pois: Dictionary = {}
	pois[POI.id3(Vector2i(10,6))] = create_quest1()
	pois[POI.id3(Vector2i(24,9))] = create_quest2()
	pois[POI.id3(Vector2i(42,7))] = create_quest3()
	var market: Factory = GameService.create_default_factory(Types.POI_TYPES.MARKET)
	market.recipes = []
	market.recipes.append(Recipe.new(
		[InventoryItem.new(Types.ITEM.APPLE)],
		Types.ITEM.WHEAT,
		1,
		0))
	pois[POI.id3(Vector2i(43,19))] = market
	pois[POI.id3(Vector2i(34,16))] = GameService.create_default_factory(Types.POI_TYPES.WINDMILL)
	pois[POI.id3(Vector2i(27,17))] = GameService.create_default_factory(Types.POI_TYPES.BAKERY)
	pois[POI.id3(Vector2i(27,17))] = GameService.create_default_factory(Types.POI_TYPES.BAKERY)
	pois[POI.id3(Vector2i(29,21))] = create_quest4()
	pois[POI.id3(Vector2i(25,31))] = Exit.new("Boat is ready, you can go...")
	GameService.set_pois(pois)

func create_quest4() -> Quest:
	return Quest.new(
		"The barrier",
		"I can open barrier but, I'm hungry. "
		+"Bring me bread and I will open the barrier.",
		[InventoryItem.new(Types.ITEM.BREAD, 1)],
		"Ok, you can go...",
		quest4_action,
	)

func quest4_action():
	var tilemap: TileMap = GameService.get_tilemap()
	tilemap.set_cell(Types.MAP_LAYERS.BUILDINGS, Vector2i(30,22))
	tilemap.set_cell(Types.MAP_LAYERS.PATH, Vector2i(30,22), 0, Vector2i(11, 56))
	PathService.update_path(tilemap.get_used_cells(Types.MAP_LAYERS.PATH))

func create_quest3() -> Quest:
	return Quest.new(
		"What it is about...",
		"Main goal is to reach finish. To do it, you need to buy"
		+"and sell thing to complete main quest, and unlock path. Lets try...",
		[],
		"Apple will be helpfull.",
		quest3_action,
	)

func quest3_action():
	SoundService.play(player, SoundService.SOUND_TYPE.EXPLOSION)
	explosion.play("default")
	SignalsService.on_camera_shake.emit(4.0)
	var tilemap: TileMap = GameService.get_tilemap()
	tilemap.set_cell(Types.MAP_LAYERS.BUILDINGS, Vector2i(41,16))
	tilemap.set_cell(Types.MAP_LAYERS.PATH, Vector2i(41,15), 0, Vector2i(3, 52))
	tilemap.set_cell(Types.MAP_LAYERS.PATH, Vector2i(41,16), 0, Vector2i(3, 52))
	tilemap.set_cell(Types.MAP_LAYERS.PATH, Vector2i(41,17), 0, Vector2i(3, 52))
	PathService.update_path(tilemap.get_used_cells(Types.MAP_LAYERS.PATH))
	marker_3.visible = false
	

func create_quest2() -> Quest:
	return Quest.new(
		"Stops!",
		"During the game you can stop at "
		+STOP_FACTORY_CODE+" workshops where you can buy and sell things, "
		+STOP_QUEST_CODE +" quest that can unlock variety of things and "
		+ "at " +STOP_EXIT_CODE+" level finish.",
		[],
		"You got an apple! Don't eat it, it may be useful.\nNow proceed to next marker. ",
		quest2_action,
	)

func quest2_action():
	SoundService.play(player, SoundService.SOUND_TYPE.WOOD_WORKING)
	var tilemap: TileMap = GameService.get_tilemap()
	GameService.add_to_inventory(Types.ITEM.APPLE, 1)
	tilemap.set_cell(Types.MAP_LAYERS.BUILDINGS, Vector2i(36,7))
	tilemap.set_cell(Types.MAP_LAYERS.PATH, Vector2i(36,7), 0, Vector2i(8, 35))
	PathService.update_path(tilemap.get_used_cells(Types.MAP_LAYERS.PATH))
	marker_2.visible = false
	marker_3.visible = true

func create_quest1() -> Quest:
	return Quest.new(
		"Controls!",
		"Use "+MOUSE_LEFT_ICON_CODE+" left button to select destination."
		+" Hold "+MOUSE_RIGHT_ICON_CODE+" right button to move map around."
		+" Use scroll "+MOUSE_MIDDLE_ICON_CODE+" to change zoom."
		+" Click FINISH to unlock path.",
		[],
		"Now proceed to next marker.",
		quest1_action,
	)

func quest1_action():
	SoundService.play(player, SoundService.SOUND_TYPE.WOOD_WORKING)
	var tilemap: TileMap = GameService.get_tilemap()
	tilemap.set_cell(Types.MAP_LAYERS.BUILDINGS, Vector2i(18,7))
	tilemap.set_cell(Types.MAP_LAYERS.PATH, Vector2i(18,7), 0, Vector2i(8, 35))
	PathService.update_path(tilemap.get_used_cells(Types.MAP_LAYERS.PATH))
	marker_1.visible = false
	marker_2.visible = true


func _on_explosion_animation_finished():
	explosion.visible = false
