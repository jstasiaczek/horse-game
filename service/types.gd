extends Node

enum MAP_LAYERS {
	WATER,
	GROUND,
	GROUND2,
	PATH,
	BUILDINGS,
	NAVIGATE,
	HOVER,
}

enum POI_TYPES {
	NONE,
	MARKET,
	BAKERY,
	LUMBERJACK,
	ORCHARD,
	WINDMILL,
	FARM,
	PORT,
	EXIT,
	QUEST
}

const POI_NAMES: Dictionary = {
	POI_TYPES.MARKET: "Market",
	POI_TYPES.BAKERY: "Bakery",
	POI_TYPES.LUMBERJACK: "Lumberjack",
	POI_TYPES.ORCHARD: "Orchard",
	POI_TYPES.WINDMILL: "Windmill",
	POI_TYPES.FARM: "Farm",
	POI_TYPES.PORT: "Port",
	POI_TYPES.NONE: "",
	POI_TYPES.QUEST: "Quest",
	POI_TYPES.EXIT: "Exit"
}

enum POI_ACTON_TYPE {
	FACTORY,
	QUEST,
	EXIT
}

enum ITEM {
	BREAD,
	WOOD,
	APPLE,
	FLOUR,
	WHEAT,
	FISH,
	COIN
}

func _get_image_small(small: bool):
	if small:
		return "small_"
	return ""

func get_item_icon_path(item: ITEM, small: bool = false) -> String:
	match item:
		ITEM.BREAD:
			return "res://assets/items/"+_get_image_small(small)+"bread.png"
		ITEM.APPLE:	
			return "res://assets/items/"+_get_image_small(small)+"apple.png"
		ITEM.COIN:
			return "res://assets/items/"+_get_image_small(small)+"coin.png"
		ITEM.FISH:
			return "res://assets/items/"+_get_image_small(small)+"fish.png"
		ITEM.FLOUR:
			return "res://assets/items/"+_get_image_small(small)+"flour.png"
		ITEM.WHEAT:
			return "res://assets/items/"+_get_image_small(small)+"wheat.png"
		ITEM.WOOD:
			return "res://assets/items/"+_get_image_small(small)+"wood.png"
	return "res://assets/icons/question_mark.png"

class InventoryItem:
	var item: ITEM
	var count: int = 1

func new_inventory_item(item: ITEM, count: int = 1) -> InventoryItem:
	var inv: InventoryItem = InventoryItem.new()
	inv.item = item
	inv.count = count
	return inv

class Recipe:
	var input: Array[ITEM] =[]
	var output: ITEM
	var output_count: int = 1
	var time: int = 60
	var player_required: bool = false

func new_recipe(input: Array[ITEM], output: ITEM, output_count: int = 1, time: int = 1, player_required: bool = false) -> Recipe:
	var rec = Recipe.new()
	rec.input = input
	rec.output = output
	rec.output_count = output_count
	rec.time = time
	rec.player_required = player_required
	return rec

class Factory:
	var type: POI_TYPES
	var action_type: POI_ACTON_TYPE = POI_ACTON_TYPE.FACTORY
	var recipe_queue: Array[Recipe] = []
	var recipes: Array[Recipe] = []
	var output: Array[ITEM] = []
	var working_minutes: int = 0
	func add_time(value: int):
		if has_doable_queue():
			working_minutes += value
		else:
			reset_working()
	func has_doable_queue() -> bool:
		return recipe_queue.filter(func (recipe: Recipe): return recipe.player_required == false).size() > 0
	func has_queue() -> bool:
		return recipe_queue.size() > 0
	func reset_working():
		working_minutes = 0
	func is_current_recipe_finished():
		return has_queue() && working_minutes >= recipe_queue[0].time
	func process() -> bool:
		var is_output: bool = false
		var copy = recipe_queue.duplicate(true)
		var result: Array[Recipe] = []
		for recipe in copy:
			if is_current_recipe_finished() and not recipe.player_required:
				reset_working()
				for i in range(recipe.output_count):
					output.append(recipe.output)
					is_output = true
			else:
				result.append(recipe)
		recipe_queue = result
		return is_output

func new_factory(type: POI_TYPES, recipes: Array[Recipe]) -> Factory:
	var fact = Factory.new()
	fact.type = type
	fact.recipes = recipes
	return fact

func get_poi_name_by_type(type: POI_TYPES) -> String:
	return POI_NAMES[type]

class Quest:
	var type: POI_TYPES = POI_TYPES.QUEST
	var action_type: POI_ACTON_TYPE = POI_ACTON_TYPE.QUEST
	var title: String
	var desc: String
	var input: Array[InventoryItem]
	var is_finished: bool = false
	var finished_desc: String
	var action: Callable

func new_quest(title: String, desc: String, input: Array[InventoryItem], finished_desc: String, action: Callable) -> Quest:
	var inst: Quest = Quest.new()
	inst.title = title
	inst.desc = desc
	inst.input = input
	inst.finished_desc = finished_desc
	inst.action = action
	return inst

class Exit:
	var type: POI_TYPES = POI_TYPES.EXIT
	var desc: String
	var action_type: POI_ACTON_TYPE = POI_ACTON_TYPE.EXIT

func new_exit(desc: String) -> Exit:
	var inst: Exit = Exit.new()
	inst.desc = desc
	return inst
