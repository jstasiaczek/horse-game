extends Control
@onready var title_label = $CC/WoodPanel/MC/VB/TitleLabel
@onready var desc_label = $CC/WoodPanel/MC/VB/DescLabel

var title: String
var desc: String

func _ready():
	title_label.text = title
	desc_label.text = desc

func _on_stay_button_pressed():
	SignalsService.on_info_hud_close.emit()
