extends Control
@onready var stay_button = $CC/WoodPanel/MC/HB/StayButton
@onready var next_button = $CC/WoodPanel/MC/HB/NextButton
@onready var desc_label = $CC/WoodPanel/MC/VB/DescLabel

var exit: Exit
var id: Vector2i

func _ready():
	desc_label.text = exit.desc
	SignalsService.on_fade_in_finished.connect(on_fade_in_finished)

func _on_stay_button_pressed():
	SignalsService.on_exit_gui_close.emit(id)


func _on_next_button_pressed():
	SignalsService.on_start_fade_in.emit()

func on_fade_in_finished():
	GameService.load_level_select()
	
