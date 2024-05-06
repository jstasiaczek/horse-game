extends Control
@onready var veil = $Veil

const FADE_IN_NAME: String = "fade_in"
const FADE_OUT_NAME: String = "fade_out"

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true
	SignalsService.on_start_fade_in.connect(on_start_fade_in)
	SignalsService.on_start_fade_out.connect(on_start_fade_out)

func on_start_fade_in():
	if get_tree() == null:
		return
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "visible", true, 0)
	tween.tween_property(veil, "color:a", 0, 0)
	tween.tween_property(veil, "color:a", 1, 0.5)
	tween.tween_callback(func (): SignalsService.on_fade_in_finished.emit())
	tween.play()

func on_start_fade_out():
	if get_tree() == null:
		return
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "visible", true, 0)
	tween.tween_property(veil, "color:a", 1, 0)
	tween.tween_property(veil, "color:a", 0, 0.5)
	tween.tween_property(self, "visible", false, 0)
	tween.tween_callback(func (): SignalsService.on_fade_out_finished.emit())
	tween.play()
