extends Control
@onready var time_label = $ColorRect/CenterContainer/VBoxContainer/timeLabel
@onready var timer = $Timer
@onready var color_rect = $ColorRect
@onready var label = $ColorRect/CenterContainer/VBoxContainer/Label

var poi_id: Vector2i
var recipe: Recipe
var start_time: int
var is_finished: bool = false

func _ready():
	start_time = GameService.time.get_minutes()
	SignalsService.on_time_changed.connect(on_time_changed)
	fade_in()

func fade_in():
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(time_label, "visible", false, 0)
	tween.tween_property(label, "visible", false, 0)
	tween.tween_property(color_rect, "color:a", 0, 0)
	tween.tween_property(color_rect, "color:a", 1, 0.5)
	tween.tween_property(time_label, "visible", true, 0)
	tween.tween_property(label, "visible", true, 0)
	tween.play()

func fade_out():
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(time_label, "visible", false, 0)
	tween.tween_property(label, "visible", false, 0)
	tween.tween_property(color_rect, "color:a", 1, 0)
	tween.tween_property(color_rect, "color:a", 0, 0.5)
	tween.tween_callback(func (): SignalsService.on_wait_hud_close.emit())
	tween.play()

func on_time_changed():
	time_label.text = GameService.time.format()
	var delta: int = GameService.time.get_minutes() - start_time
	if delta < recipe.time or is_finished:
		return
	is_finished = true
	timer.stop()
	GameService.add_item_to_output(poi_id, recipe)
	GameService.set_horse_tired()
	fade_out()

func _on_timer_timeout():
	GameService.time.add_minutes(GameService.MINUTES_ADD_ON_TICK)
