class_name Recipe

var input: Array[Types.ITEM] =[]
var output: InventoryItem
var time: int = 60
var player_required: bool = false


func _init(inp: Array[Types.ITEM], out: Types.ITEM, out_count: int = 1, t: int = 1, req: bool = false):
	input = inp
	output = InventoryItem.new(out, out_count)
	time = t
	player_required = req
