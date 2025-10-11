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


func pack_data(data) -> Dictionary:
	return {}


func unpack_data(data) -> void:
	pass