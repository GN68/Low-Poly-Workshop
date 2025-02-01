extends Node3D
class_name Gizmo
## Base class for all gizmos

@export var color : Color = Color.WHITE : set = set_color
func set_color(new_color : Color) -> void:
	color = new_color