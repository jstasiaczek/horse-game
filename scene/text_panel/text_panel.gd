extends Panel
@onready var label = $MG/Label

func set_text(value: String):
	if label == null:
		return
	label.text = value

func set_font_size(value: int):
	label.add_theme_font_size_override("normal_font_size", value)
