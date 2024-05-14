extends AudioStreamPlayer

func _ready():
	SignalsService.on_button_click.connect(on_button_click)

func on_button_click():
	play()
