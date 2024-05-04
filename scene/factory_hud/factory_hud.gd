extends Control
const RECIPE = preload("res://scene/factory_hud/recipe.tscn")
@onready var recipe_container = $CC/WoodPanel/MG/VB/RecipeContainer
@onready var factory_title = $CC/WoodPanel/MG/VB/FactoryTitle
@onready var queue = $CC/WoodPanel/MG/VB2/Queue
@onready var output = $CC/WoodPanel/MG/VB2/Output
@onready var progress_bar = $CC/WoodPanel/MG/VB2/Control/ProgressBar

var id = Vector2i(8,4)
# Called when the node enters the scene tree for the first time.
func _ready():
	create_recipe_list(id)
	update_queue_list(id)
	update_output_list(id)
	update_progress()
	update_title()
	SignalsService.on_factory_queue_update.connect(update_queue_list)
	SignalsService.on_factory_output_update.connect(update_output_list)
	SignalsService.on_inventory_update.connect(on_inventory_update)
	SignalsService.on_time_changed.connect(update_progress)
	SignalsService.on_horse_rested.connect(refresh_recipe_list)
	SignalsService.on_horse_tired.connect(refresh_recipe_list)

func refresh_recipe_list():
	create_recipe_list(id)

func update_progress():
	var factory = get_factory(id)
	if factory == null or factory.has_doable_queue() == false:
		set_progress(factory, true)
		return
	set_progress(factory)

func set_progress(factory: Types.Factory, clear: bool = false):
	if clear == true:
		progress_bar.value = 0
		progress_bar.visible = false
		return
	var expected_time = factory.recipe_queue[0].time
	progress_bar.visible = true
	if factory.working_minutes >= expected_time:
		progress_bar.value = 200
		return
	var value = (float(factory.working_minutes) / float(expected_time)) * 200
	progress_bar.value = value
	
func on_inventory_update():
	create_recipe_list(id)

func update_title():
	var type: Types.POI_TYPES = GameService.get_poi_by_id(id).type
	factory_title.text = Types.get_poi_name_by_type(type)

func get_factory(id):
	var config: Types.Factory = GameService.get_poi_by_id(id)
	if config == null or config.action_type != Types.POI_ACTON_TYPE.FACTORY:
		return null
	return config

func create_recipe_list(id: Vector2i):
	print("create list")
	for child in recipe_container.get_children():
		recipe_container.remove_child(child)
	var config = get_factory(id)
	if config == null:
		return
	for recipe in config.recipes:
		var inst = RECIPE.instantiate()
		inst.recipe = recipe
		inst.poi_id = id
		recipe_container.add_child(inst)

func update_output_list(poi_id: Vector2i):
	if poi_id != id:
		return
	var factory = get_factory(id)
	var desc: String = ""
	if factory == null:
		return
	for item in factory.output:
		desc += "[img]"+Types.get_item_icon_path(item)+"[/img] "
	output.text = desc


func update_queue_list(poi_id: Vector2i):
	if poi_id != id:
		return
	var factory = get_factory(id)
	var desc: String = ""
	if factory == null:
		return
	for item in factory.recipe_queue:
		desc += "[img]"+Types.get_item_icon_path(item.output.item)+"[/img] "
	queue.text = desc



func _on_exit_button_pressed():
	SignalsService.on_factory_gui_close.emit(id)


func _on_collect_button_pressed():
	var poi = GameService.get_poi_by_id(id)
	if poi == null or poi.action_type != Types.POI_ACTON_TYPE.FACTORY:
		return
	for el in poi.output:
		GameService.add_to_inventory(el)
	GameService.clear_factory_output(id)
