class_name Passage

var type: Types.POI_TYPES = Types.POI_TYPES.PASSAGE
var action_type: Types.POI_GROUP_TYPE = Types.POI_GROUP_TYPE.PASSAGE
var callback: Callable

func _init(clb: Callable):
	callback = clb
