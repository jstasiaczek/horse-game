extends HBoxContainer
const ARROW_ICON_CODE: String = "[img]res://assets/icons/arrow_right.png[/img] "
const PLUS_ICON_CODE: String = "[img]res://assets/icons/plus.png[/img] "
const HORSE_ICON_CODE: String = "[img]res://assets/icons/horse.png[/img] "

@onready var reciepe_desc = $ReciepeDesc
@onready var disabled_button = $DisabledButton
@onready var make_button = $MakeButton

var recipe: Recipe
var poi_id: Vector2i
# Called when the node enters the scene tree for the first time.
func _ready():
	var desc: String = "[right]"
	if recipe == null:
		return
	if recipe.time > 0:
		desc += "%.1fh " % (recipe.time / 60.0)
	for i in range(recipe.input.size()):
		var item = recipe.input[i]
		desc += "[img]"+ Types.get_item_icon_path(item) +"[/img] "
		if i+1 < recipe.input.size():
			desc += PLUS_ICON_CODE
	if recipe.player_required:
		if recipe.input.size() > 0:
			desc += PLUS_ICON_CODE
		desc += HORSE_ICON_CODE
	desc += ARROW_ICON_CODE
	if recipe.output.count > 1:
		desc += "%s " % recipe.output.count
	desc += "[img]"+Types.get_item_icon_path(recipe.output.item)+"[/img]"
	desc += "[/right]"
	reciepe_desc.text = desc + "  "
	if GameService.can_pay_for_recipe(recipe) == false or (recipe.player_required and GameService.is_horse_tired()):
		make_button.visible = false
		disabled_button.visible = true
	else:
		make_button.visible = true
		disabled_button.visible = false

func _on_make_button_pressed():
	if recipe.player_required:
		SignalsService.on_wait_hud_display.emit(poi_id, recipe)
	else:
		GameService.pay_for_recipe(recipe)
		GameService.add_recipe_to_queue(poi_id, recipe)
