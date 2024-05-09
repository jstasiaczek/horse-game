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
	QUEST,
	CALLBACK,
	MINE,
	BLACKSMITH,
	ALCHEMIST,
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
	POI_TYPES.EXIT: "Exit",
	POI_TYPES.CALLBACK: "Passage",
	POI_TYPES.MINE: "Mine",
	POI_TYPES.BLACKSMITH: "Blacksmith",
	POI_TYPES.ALCHEMIST: "Alchemist",
}

enum POI_GROUP_TYPE {
	FACTORY,
	QUEST,
	EXIT,
	CALLBACK,
}

enum ITEM {
	BREAD,
	WOOD,
	APPLE,
	FLOUR,
	WHEAT,
	FISH,
	COIN,
	IRON,
	PICKAXE,
	TNT
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
		ITEM.IRON:
			return "res://assets/items/"+_get_image_small(small)+"iron.png"
		ITEM.PICKAXE:
			return "res://assets/items/"+_get_image_small(small)+"pickaxe.png"
		ITEM.TNT:
			return "res://assets/items/"+_get_image_small(small)+"tnt.png"
	return "res://assets/icons/question_mark.png"

func get_poi_name_by_type(type: POI_TYPES) -> String:
	return POI_NAMES[type]

