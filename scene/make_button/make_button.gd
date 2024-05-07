extends TextureButton
const NORMAL_HOVER = preload("res://assets/ui/make_button-hover.png")
const NORMAL_PRESSED = preload("res://assets/ui/make_button-pressed.png")
const NORMAL = preload("res://assets/ui/make_button.png")
const NORMAL_DISABLED = preload("res://assets/ui/make_button_disabled.png")
const MANY_HOVER = preload("res://assets/ui/make_button_many-hover.png")
const MANY_PRESSED = preload("res://assets/ui/make_button_many-pressed.png")
const MANY = preload("res://assets/ui/make_button_many.png")
const MANY_DISABLED = preload("res://assets/ui/make_button_many_disabled.png")
@onready var count_label = $Count

enum TYPE {NORMAL,MANY}

@export var type: TYPE = TYPE.NORMAL
@export var count: String = "5"

# Called when the node enters the scene tree for the first time.
func _ready():
	if type == TYPE.NORMAL:
		texture_normal = NORMAL
		texture_pressed = NORMAL_PRESSED
		texture_hover = NORMAL_HOVER
		texture_disabled = NORMAL_DISABLED
		count_label.visible = false
	else:
		texture_normal = MANY
		texture_pressed = MANY_PRESSED
		texture_hover = MANY_HOVER
		texture_disabled = MANY_DISABLED
		count_label.visible = true
		count_label.text = count

func do_disabled(value: bool):
	if value:
		count_label.modulate.a = 0.7
	else:
		count_label.modulate.a = 1.0
	disabled = value
