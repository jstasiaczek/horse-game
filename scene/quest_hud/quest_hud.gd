extends Control
@onready var title_label = $CC/WoodPanel/MC/VB/TitleLabel
@onready var desc_label = $CC/WoodPanel/MC/VB/DescLabel
@onready var items_desc = $CC/WoodPanel/MC/VB/ItemsDesc
@onready var finish_button = $CC/WoodPanel/MC/HB/FinishButton
@onready var items_label = $CC/WoodPanel/MC/VB/ItemsLabel

var quest: Types.Quest
var id: Vector2i

func _ready():
	title_label.text = quest.title
	create_desc()
	setup_button()
	create_items_desc()

func setup_button():
	finish_button.visible = not quest.is_finished

func create_desc():
	if quest.is_finished:
		desc_label.text = quest.finished_desc
	else:
		desc_label.text = quest.desc

func create_items_desc():
	var desc: String = ""
	if quest.input.is_empty():
		items_label.visible = false
		items_desc.visible = false
	for el in quest.input:
		if el.count > 1:
			desc += "%2d" % el.count
		desc += "[img]"+Types.get_item_icon_path(el.item)+"[/img] "
	items_desc.text = desc

func _on_finish_button_pressed():
	var item_collected: bool = true
	for el in quest.input:
		if GameService.has_in_inventory(el.item, el.count) == false:
			item_collected = false
	if item_collected == false:
		desc_label.text = "Sorry, it looks like you don't have all the required items!"
		return
	for el in quest.input:
		GameService.remove_from_inventory(el.item, el.count)
	quest.is_finished = true
	create_desc()
	setup_button()
	quest.action.call()


func _on_exit_button_pressed():
	SignalsService.on_quest_gui_close.emit(id)
