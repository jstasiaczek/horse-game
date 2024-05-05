class_name Quest

var type: Types.POI_TYPES = Types.POI_TYPES.QUEST
var action_type: Types.POI_ACTON_TYPE = Types.POI_ACTON_TYPE.QUEST
var title: String
var desc: String
var input: Array[InventoryItem]
var is_finished: bool = false
var finished_desc: String
var action: Callable

func _init(t: String, d: String, i: Array[InventoryItem], fd: String, a: Callable):
	title = t
	desc = d
	input = i
	finished_desc = fd
	action = a
