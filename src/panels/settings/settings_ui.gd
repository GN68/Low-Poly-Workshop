extends Control

@onready var CategoriesButtons = $HBoxContainer/CategoriesPanel/ScrollContainer/CategoriesButtons
@onready var OptionsButtons = $HBoxContainer/OptionsPanel/ScrollContainer/OptionsButtons

enum OPTION_TYPE {
	BOOLEAN,
	STRING,
	NUMBER,
	LIST,
	COLOR,
	KEYBIND,
}


@export var options: Dictionary[OPTION_TYPE,PackedScene]

func _ready():
	for child in OptionsButtons.get_children(): child.queue_free()
	for category in Settings.get_categories():
		for option in Settings.get_category_options(category):
			var option_instance = options[option.type].instantiate()
			option_instance.option_name = option.name
			OptionsButtons.add_child(option_instance)
		return