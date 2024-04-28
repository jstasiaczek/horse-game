extends TextureButton
@onready var label = $Label

var text: String = ""
var level: String = ""

func _ready():
	label.text = text

func set_text(value: String):
	text = value
	label.text = value

func _on_button_up():
	label.position.y = 0


func _on_button_down():
	label.position.y = 2


func _on_pressed():
	GameService.load_map(level)
	
