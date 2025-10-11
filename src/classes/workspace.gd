extends Node
class_name Workspace

@export var source_path : String
@export var unsaved_changes : bool
@export var objects : Array
# this is the root instead of the node itself to avoid being able to get nodes in the editor.


## Add an object to the workspace
func add_object(object : LPWObject):
	objects.append(object)
	add_child(object)