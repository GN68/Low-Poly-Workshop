extends Node

var _options = {}

signal option_changed(name: String, data: Variant)

enum OPTION_TYPE {
	BOOLEAN,
	STRING,
	NUMBER,
	RANGE,
	LIST,
	COLOR,
	KEYBIND,
}

## Registers a callback function that will get called when the given name option is modified.
func listen_for_option(name: String, callback: Callable) -> void:
	if _options.has(name):
		_options[name].callbacks.append(callback)
	else: 
		push_error("Attempted to listen for an option \""+name+"\", which doesn't exist.")


func _error(name: String, to: String):
	push_error("Attempted to set an option \""+name+"\" to a non-"+to+" value.")


func get_option(name: String) -> Dictionary:
	return _options[name]


func has_option(name: String) -> bool:
	return _options.has(name)

## ============================ Option Registry ============================ ##

func _register_option(category: String, name: String, type: OPTION_TYPE, default_value: Variant, data: Variant = null) -> void:
	if !_options.has(category): _options[category] = {}
	if _options[category].has(name): 
		push_error("Attempted to register an option \""+name+"\", which already exists.")
	_options[name] = {type = type, data = data, value = default_value, callbacks = []}


## Registers a boolean option.
func register_bool(category: String, name: String, default_value: bool) -> void:
	_register_option(category ,name, OPTION_TYPE.BOOLEAN, default_value)


## Registers a string option.
func register_string(category: String, name: String, default_value: String) -> void:
	_register_option(category ,name, OPTION_TYPE.STRING, default_value)


## Registers a number option.
func register_number(category: String, name: String, default_value: float, step: float = 0) -> void:
	_register_option(category ,name, OPTION_TYPE.NUMBER, default_value,{step = step})


## Registers a range option.
func register_range(category: String, name: String, default_value: float,from: float, to:float, step: float = 0) -> void:
	_register_option(category ,name, OPTION_TYPE.RANGE, default_value, {from = min(from,to), to = max(from,to),step = step})


## Registers a list option.
func register_list(category: String, name: String, default_value: int, list: Array[String]) -> void:
	_register_option(category ,name, OPTION_TYPE.LIST, default_value, list)

## Registers a keybind option. the default value is an array of [Key]s
func register_keybind(category: String, name: String, default_value: Array[Key]) -> void:
	_register_option(category ,name, OPTION_TYPE.KEYBIND, default_value)

## Registers a color option.
func register_color(category: String, name: String, default_value: Color) -> void:
	_register_option(category ,name, OPTION_TYPE.COLOR, default_value)

## ============================ Option Setters ============================ ##


## Sets the value of an option.
func set_option(category: String,name: String, value: Variant) -> void:
	if !_options.has(name): push_error("Attempted to set an option \""+name+"\", which doesn't exist.")
	var option = _options[name]
	match option.type:
		OPTION_TYPE.BOOLEAN:
			if value is bool: option.value = value
			else: _error(name, "bool")
		OPTION_TYPE.STRING:
			if value is String: option.value = value
			else: _error(name, "String")
		OPTION_TYPE.NUMBER:
			if value is float: option.value = value
			else: _error(name, "float")
		OPTION_TYPE.RANGE:
			if value is float: option.value = value
			else: _error(name, "float")
		OPTION_TYPE.LIST:
			if value is int: option.value = value
			else: _error(name, "int")
		OPTION_TYPE.KEYBIND:
			if value is Array[Key]: option.value = value
			else: _error(name, "Array[Key]")
		OPTION_TYPE.COLOR:
			if value is Color: option.value = value
			else: _error(name, "Color")

	for callback in option.callbacks:
		callback.emit(option.value)