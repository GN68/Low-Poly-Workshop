extends Control
class_name SettingsOption

enum OPTION_TYPE {
	BOOLEAN,
	STRING,
	NUMBER,
	LIST,
	COLOR,
	KEYBIND,
}

@export var option_name: String : set = _set_option
@export var category: String : set = _set_category
@export var type: OPTION_TYPE : set = _set_type


func _set_option(value: String) -> void:
	if !option_name: option_name = value # only allow the type to be set once


func _set_category(value: String) -> void:
	if !category: category = value # only allow the type to be set once


func _set_type(value: OPTION_TYPE) -> void:
	if !type: type = value # only allow the type to be set once