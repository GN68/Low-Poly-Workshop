extends Node
# The Editor global

var workspaces : Array[Workspace] = []
var current_workspace : Workspace: set = set_workspace


func _ready() -> void:
	set_workspace(Workspace.new())


func set_workspace(new_workspace):
	if current_workspace: remove_child(current_workspace)
	current_workspace = new_workspace
	if !is_node_ready(): await ready
	add_child(current_workspace)


func create_mesh():
	assert(current_workspace is Workspace, "Current Workspace does not exist or is not a Workspace")
	
	var object = LPWMesh.new()
	current_workspace.add_object(object)
