extends LPWObject
class_name LPWGroup


func _init() -> void:
	name = "Group"


func get_icon_name() -> String:
	return "group"



func pack_data(data) -> Dictionary:
	return {
		position = position,
		rotation = rotation,
		scale = scale,
	}


func unpack_data(data) -> void:
	position = data.position
	rotation = data.rotation
	scale = data.scale