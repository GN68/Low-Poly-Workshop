extends LPWObject
class_name LPWMesh

@export var mesh : Mesh : set = set_mesh
var mesh_instance : MeshInstance3D


func set_mesh(new_mesh : Mesh):
	mesh = new_mesh
	mesh_instance.mesh = mesh


func _init():
	mesh_instance = MeshInstance3D.new()
	add_child(mesh_instance)
	mesh = BoxMesh.new()
	name = "Mesh"


func get_icon_name() -> String:
	return "mesh"


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