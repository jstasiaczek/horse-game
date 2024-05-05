class_name Factory

var type: Types.POI_TYPES
var action_type: Types.POI_ACTON_TYPE = Types.POI_ACTON_TYPE.FACTORY
var recipe_queue: Array[Recipe] = []
var recipes: Array[Recipe] = []
var output: Array[InventoryItem] = []
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
			if recipe.output.count > 0:
				output = InventoryTool.add_to_inventory(output, recipe.output.item, recipe.output.count)
				is_output = true
		else:
			result.append(recipe)
	recipe_queue = result
	return is_output

func _init(t: Types.POI_TYPES, r: Array[Recipe]):
	type = t
	recipes = r
