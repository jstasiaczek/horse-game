extends Control
const LEVEL_BUTTON = preload("res://scene/level_button/level_button.tscn")
@onready var levels_container = $Background/MC/VB/LevelsContainer

var levels: Array[Dictionary] = [
	{
		"name": "Tutorial",
		"path": "res://level/level0/level0.tscn",
	},
	{
		"name": "1",
		"path": "res://level/level1/level1.tscn",
	},
] 

func _ready():
	for level in levels:
		var inst = LEVEL_BUTTON.instantiate()
		inst.text = level.name
		inst.level = level.path
		levels_container.add_child(inst)
