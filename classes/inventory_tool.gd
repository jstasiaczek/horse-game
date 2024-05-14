class_name InventoryTool

static func get_empty() -> Array[InventoryItem]:
	return []


static func has_in_inventory(inventory: Array[InventoryItem], item: Types.ITEM, count: int = 1) -> bool:
	for el in inventory:
		if el.item == item and el.count >= count:
			return true
	return false

static func can_pay_for_recipe(inventory: Array[InventoryItem], recipe: Recipe, recipe_count: int = 1) -> bool:
	for el in recipe.input:
		if not has_in_inventory(inventory, el.item, recipe_count * el.count):
			return false
	return true

static func pay_for_recipe(inventory: Array[InventoryItem], recipe: Recipe) -> Array[InventoryItem]:
	for el in recipe.input:
		inventory = remove_from_inventory(inventory, el.item, el.count)
	return inventory.duplicate(true)

static func remove_from_inventory(inventory: Array[InventoryItem], item: Types.ITEM, count: int = 1) -> Array[InventoryItem]:
	var new_inventory: Array[InventoryItem] = []
	for el in inventory:
		if el.item == item:
			if el.count > count:
				el.count -= count
				new_inventory.append(el)
		else:
			new_inventory.append(el)
	return new_inventory.duplicate(true)


static func add_to_inventory(inventory: Array[InventoryItem], item: Types.ITEM, count: int = 1) -> Array[InventoryItem]:
	var is_in_inventory = false
	for idx in range(inventory.size()):
		if inventory[idx].item == item:
			inventory[idx].count += count
			is_in_inventory = true
	if not is_in_inventory:
		inventory.append(InventoryItem.new(item, count))
	return inventory.duplicate(true)
