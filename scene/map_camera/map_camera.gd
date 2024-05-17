extends Camera2D

var drag_start_pos: Vector2
var is_drag: bool = false

var decay: float = 0.8  # How quickly the shaking stops [0, 1].
var max_offset: Vector2i = Vector2i(50, 50)  # Maximum hor/ver shake in pixels.
var max_roll: float = 0.1  # Maximum rotation in radians (use sparingly).
var trauma: float = 0.0  # Current shake strength.
var trauma_power: float = 2.0  # Trauma exponent. Use [2, 3].


func _ready():
	SignalsService.on_set_horse_map_id.connect(on_set_horse_map_id)
	SignalsService.on_camera_shake.connect(on_camera_shake)
	randomize()

func on_camera_shake(duration: float):
	add_trauma(duration)

func _process(delta):
	if trauma > 0:
		trauma = max(trauma - decay * delta, 0)
		shake()

func shake():
	var amount: float = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-1.0, 1.0)
	offset.x = max_offset.x * amount * randf_range(-1.0, 1.0)
	offset.y = max_offset.y * amount * randf_range(-1.0, 1.0)

func add_trauma(amount: float):
	trauma = min(trauma + amount, 1.0)

func on_set_horse_map_id(id: Vector2i):
	var map: TileMap = GameService.get_tilemap()
	if map == null:
		return
	set_pos(map.map_to_local(id) - (get_current_size() / 2))

func _unhandled_input(_event):
	handle_drag()
	handle_scroll()

func get_current_size() -> Vector2:
	return get_canvas_transform().affine_inverse().basis_xform(get_viewport_rect().size)

func set_pos(new_position: Vector2):
	var current_size = get_current_size()
	var width: int = GameService.get_map_width_px()
	var height: int = GameService.get_map_height_px()
	
	if new_position.x > width - current_size.x:
		new_position.x = width - current_size.x

	if new_position.y > height - current_size.y:
		new_position.y = height - current_size.y
		
	if new_position.x < 0:
		new_position.x = 0

	if new_position.y < 0:
		new_position.y = 0
	
	global_position = new_position

func handle_drag():
	if Input.is_action_pressed("right_click"):
		if is_drag == false:
			is_drag = true
			drag_start_pos = get_global_mouse_position()

		var new_position = (drag_start_pos -get_global_mouse_position()) + global_position
		set_pos(new_position)
	if Input.is_action_just_released("right_click"):
		is_drag = false

func handle_scroll():
	if Input.is_action_just_pressed("scroll_up"):
		zoom = zoom + Vector2(0.1, 0.1)
		if zoom.x > GameService.MAX_ZOOM:
			zoom = Vector2(GameService.MAX_ZOOM, GameService.MAX_ZOOM)
	if Input.is_action_just_pressed("scroll_down"):
		zoom = zoom - Vector2(0.1, 0.1)
		if zoom.x < GameService.MIN_ZOOM:
			zoom = Vector2(GameService.MIN_ZOOM, GameService.MIN_ZOOM)
