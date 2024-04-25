extends Control
@onready var stay_button = $CC/WoodPanel/MC/HB/StayButton
@onready var next_button = $CC/WoodPanel/MC/HB/NextButton
@onready var desc_label = $CC/WoodPanel/MC/VB/DescLabel

var exit: Types.Exit
var id: Vector2i

func _ready():
	desc_label.text = exit.desc

func _on_stay_button_pressed():
	SignalsService.on_exit_gui_close.emit(id)
