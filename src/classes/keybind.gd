extends Resource
class_name Keybind

enum KEYBIND_ACTIVATE_ON {
	PRESS,
	RELEASE,
	BOTH
}

@export var key : Array[Key]
@export var activate_on : KEYBIND_ACTIVATE_ON = KEYBIND_ACTIVATE_ON.PRESS

func _init(key: Array[Key], activate_on: KEYBIND_ACTIVATE_ON = KEYBIND_ACTIVATE_ON.PRESS):
	self.key = key
	self.activate_on = activate_on