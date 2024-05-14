class_name Recipe

var input: Array[InventoryItem] =[]
var output: InventoryItem
var time: int = 60
var player_required: bool = false

func is_instant() -> bool:
	return time == 0


func _init(inp: Array[InventoryItem], out: Types.ITEM, out_count: int = 1, t: int = 1, req: bool = false):
	input = inp
	output = InventoryItem.new(out, out_count)
	time = t
	player_required = req
