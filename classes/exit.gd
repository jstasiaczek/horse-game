class_name Exit

var type: Types.POI_TYPES = Types.POI_TYPES.EXIT
var desc: String
var action_type: Types.POI_ACTON_TYPE = Types.POI_ACTON_TYPE.EXIT

func _init(d: String):
	desc = d
