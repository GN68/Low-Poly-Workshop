extends Node
class_name Workspace

@export var source_path : String
@export var unsaved_changes : bool

signal object_moved(object: LPWObject, new_parent: LPWObject)
signal object_removed(object: LPWObject)
signal object_added(object: LPWObject)

var scene = preload("res://debug/node_tree.tscn")


func _ready() -> void:
	add_child(scene.instantiate())


## Checks if the given object is inside the workspace
func is_inside_workspace(object: LPWObject):
	return true # TODO: make use of getPath() to check if the object is inside.


## Moves the given object to the new parent.
func move_object(object: LPWObject, new_parent: LPWObject):
	if object.get_parent():
		object.get_parent().remove_child(object)
	new_parent.add_child(object)
	object_moved.emit(object, new_parent)