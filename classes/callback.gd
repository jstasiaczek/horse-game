class_name Callback

var type: Types.POI_TYPES = Types.POI_TYPES.CALLBACK
var action_type: Types.POI_GROUP_TYPE = Types.POI_GROUP_TYPE.CALLBACK
var callback: Callable

func _init(clb: Callable):
	callback = clb
