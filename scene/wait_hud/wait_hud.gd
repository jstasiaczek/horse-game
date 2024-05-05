extends Control
@onready var time_label = $ColorRect/CenterContainer/VBoxContainer/timeLabel
@onready var timer = $Timer

var poi_id: Vector2i
var recipe: Recipe
var start_time: int

# Called when the node enters the scene tree for the first time.
func _ready():
	start_time = GameService.time.get_minutes()
	# add_minutes()
	SignalsService.on_time_changed.connect(on_time_changed)

func on_time_changed():
	time_label.text = GameService.time.format()
	var delta: int = GameService.time.get_minutes() - start_time
	if delta < recipe.time:
		return
	timer.stop()
	GameService.add_item_to_output(poi_id, recipe)
	GameService.set_horse_tired()
	SignalsService.on_wait_hud_close.emit()
	

func _on_timer_timeout():
	GameService.time.add_minutes(GameService.MINUTES_ADD_ON_TICK)
