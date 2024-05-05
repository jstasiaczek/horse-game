class_name InventoryItem

var item: Types.ITEM
var count: int = 1

func _init(i: Types.ITEM, c: int = 1):
	item = i
	count = c
