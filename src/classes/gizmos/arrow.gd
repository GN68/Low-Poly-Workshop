@tool
extends Gizmo
class_name ArrowGizmo

const HEAD_LENGTH : float = 8

@export var length : float = 1.0 : set = set_length
func set_length(new_length : float) -> void:
	length = new_length
	length = max(new_length,0.01)
	_update_mesh()

@export var width : float = 0.02 : set = set_width
func set_width(new_width : float) -> void:
	width = clampf(new_width,0.01,length / 4)
	_update_mesh()

func set_color(new_color : Color) -> void:
	color = new_color
	_update_mesh()

var display : Node3D
var material : BaseMaterial3D

var instance_stem: MeshInstance3D
var instance_head: MeshInstance3D

var mesh_stem: CylinderMesh
var mesh_head: CylinderMesh

func _ready():
	_update_mesh()


func _update_mesh() -> void:
	
	
	if !display: # generate mesh
		display = Node3D.new()
		mesh_stem = CylinderMesh.new()
		mesh_head = CylinderMesh.new()
		
		instance_stem = MeshInstance3D.new()
		instance_stem.mesh = mesh_stem
		instance_stem.name = "stem"
		
		instance_head = MeshInstance3D.new()
		instance_head.mesh = mesh_head
		instance_head.name = "head"
		
		display.add_child(instance_stem)
		display.add_child(instance_head)
		add_child(display)
		
		material = StandardMaterial3D.new()
		material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		
		instance_stem.material_override = material
		instance_head.material_override = material
	
	mesh_stem.top_radius = width * 0.5
	mesh_stem.bottom_radius = width* 0.5
	mesh_stem.height = length -width * HEAD_LENGTH
	instance_stem.position.y = -width * HEAD_LENGTH * 0.5
	mesh_stem.cap_top = false
	
	mesh_head.top_radius = 0
	mesh_head.bottom_radius = width * 2
	mesh_head.height = width * HEAD_LENGTH
	instance_head.position.y = length * 0.5 -width * HEAD_LENGTH * 0.5
	
	material.albedo_color = color
