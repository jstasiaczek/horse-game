extends Control
@onready var stay_button = $CC/WoodPanel/MC/HB/StayButton
@onready var next_button = $CC/WoodPanel/MC/HB/NextButton
@onready var desc_label = $CC/WoodPanel/MC/VB/DescLabel
@onready var level_time = $CC/WoodPanel/MC/VB/LevelTime
@onready var secret_label = $CC/WoodPanel/MC/VB/SecretLabel

var exit: Exit
var id: Vector2i

func _ready():
	desc_label.text = exit.desc
	GameService.set_level_end_time(int(Time.get_unix_time_from_system()))
	SignalsService.on_fade_in_finished.connect(on_fade_in_finished)
	level_time.text = "Time elapsed %ss" % GameService.get_level_time()
	secret_label.text = "Secrets found %s/%s" % [GameService.get_level_secret_found(), GameService.get_level_secret_max()]

func _on_stay_button_pressed():
	SignalsService.on_exit_gui_close.emit(id)

func _on_next_button_pressed():
	SignalsService.on_start_fade_in.emit()

func on_fade_in_finished():
	GameService.load_level_select()
