extends Control
@onready var poi_info = $MG/Control/PoiInfo
@onready var date_time = $MG/Control2/DateTime
@onready var horse_status_container = $MG/HorseStatusContainer
@onready var horse_status = $MG/HorseStatusContainer/HorseStatus

const HORSE_ICON_CODE: String = "[img]res://assets/icons/horse_small.png[/img]"
func _ready():
	date_time.set_text(GameService.time.format())
	poi_info.visible = false
	update_horse_info()
	SignalsService.on_poi_hover.connect(on_poi_hover)
	SignalsService.on_time_changed.connect(on_time_changed)
	SignalsService.on_inventory_update.connect(update_horse_info)

func update_horse_info():
	var inventory: Array[Types.InventoryItem] = GameService.get_inventory()
	var desc: String = HORSE_ICON_CODE + " "
	var height: int = 36
	for el in inventory:
		desc += "\n[img]"+Types.get_item_icon_path(el.item, true)+"[/img]"
		desc += "%3d" % el.count
		height += 24
	horse_status.set_text(desc)
	horse_status_container.custom_minimum_size = Vector2(80, height)

func on_time_changed():
	date_time.set_text(GameService.time.format())

func on_poi_hover(type: Types.POI_TYPES):
	if type == Types.POI_TYPES.NONE:
		poi_info.visible = false
	else:
		poi_info.visible = true
	poi_info.set_text(Types.get_poi_name_by_type(type))

