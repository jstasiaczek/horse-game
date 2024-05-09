extends Control
const LEVEL_BUTTON = preload("res://scene/level_button/level_button.tscn")
@onready var levels_container = $Background/MC/VB/LevelsContainer
var selected_level_path: String

var levels: Array[Dictionary] = [
	{
		"name": "Tutorial",
		"path": "res://level/level0/level0.tscn",
	},
	{
		"name": "1",
		"path": "res://level/level1/level1.tscn",
	},
	{
		"name": "2",
		"path": "res://level/level2/level2.tscn",
	},
] 

func _ready():
	SignalsService.on_level_select.connect(on_level_select)
	SignalsService.on_fade_in_finished.connect(on_fade_in_finished)
	SignalsService.on_start_fade_out.emit()
	for level in levels:
		var inst = LEVEL_BUTTON.instantiate()
		inst.text = level.name
		inst.level = level.path
		levels_container.add_child(inst)
	
func on_level_select(level_path: String):
	selected_level_path = level_path
	SignalsService.on_start_fade_in.emit()

func on_fade_in_finished():
	if selected_level_path != null and selected_level_path != "":
		GameService.load_map(selected_level_path)
