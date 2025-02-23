extends Control

@onready var CategoriesButtons = $HBoxContainer/CategoriesPanel/ScrollContainer/CategoriesButtons
@onready var OptionsButtons = $HBoxContainer/OptionsPanel/ScrollContainer/OptionsButtons
@onready var CategoryLabel = $HBoxContainer/OptionsPanel/CategoryLabel

@onready var CategoryButton = preload("res://panels/settings/category_button.tscn")

enum OPTION_TYPE {
	BOOLEAN,
	STRING,
	NUMBER,
	LIST,
	COLOR,
	KEYBIND,
}
@export var options: Dictionary[OPTION_TYPE,PackedScene]
var current_category: String = "": set = set_current_category


func _ready():
	reload_category_list()
	set_current_category("")


func set_current_category(category: String) -> void:
	for child in OptionsButtons.get_children(): child.queue_free()
	if Settings.has_category(category):
		category = category
		CategoryLabel.text = category
		for option in Settings.get_category_options(category):
			var option_instance = options[option.type].instantiate()
			option_instance.option_name = option.name
			OptionsButtons.add_child(option_instance)
	else:
		CategoryLabel.text = "..."
		category = ""


func reload_category_list():
	for child in CategoriesButtons.get_children(): child.queue_free()
	for category in Settings.get_categories():
		var category_instance = CategoryButton.instantiate()
		category_instance.text = category
		CategoriesButtons.add_child(category_instance)
