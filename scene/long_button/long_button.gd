extends TextureButton
@onready var label = $Label

const BUTTON_LONG_BLUE = preload("res://assets/ui/buttonLong_blue.png")
const BUTTON_LONG_BLUE_HOVER = preload("res://assets/ui/buttonLong_blue_hover.png")
const BUTTON_LONG_BLUE_PRESSED = preload("res://assets/ui/buttonLong_blue_pressed.png")
const BUTTON_LONG_BROWN = preload("res://assets/ui/buttonLong_brown.png")
const BUTTON_LONG_BROWN_HOVER = preload("res://assets/ui/buttonLong_brown_hover.png")
const BUTTON_LONG_BROWN_PRESSED = preload("res://assets/ui/buttonLong_brown_pressed.png")

enum BUTTON_COLOR { DARK, BLUE }

@export var button_color: BUTTON_COLOR = BUTTON_COLOR.DARK
@export var label_text: String = "Button"
# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = label_text
	if button_color == BUTTON_COLOR.DARK:
		texture_normal = BUTTON_LONG_BROWN
		texture_hover = BUTTON_LONG_BROWN_HOVER
		texture_pressed = BUTTON_LONG_BROWN_PRESSED
	elif button_color == BUTTON_COLOR.BLUE:
		texture_normal = BUTTON_LONG_BLUE
		texture_hover = BUTTON_LONG_BLUE_HOVER
		texture_pressed = BUTTON_LONG_BLUE_PRESSED

func _on_button_up():
	position.y = 0


func _on_button_down():
	position.y = 4
	pass # Replace with function body.
