@tool
extends Gizmo
class_name ArrowGizmo

const HEAD_LENGTH : float = 8

@export var length : float = 1.0 : set = set_length
@export var width : float = 0.02 : set = set_width

var material : BaseMaterial3D

@onready var instance_stem: MeshInstance3D = $MeshStem
@onready var instance_head: MeshInstance3D = $MeshHead
@onready var collision_shape: CollisionShape3D = $DragArea/CollisionShape3D

func _ready():
	material = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	
	instance_stem.material_override = material
	instance_head.material_override = material
	_update_mesh()
	collision_shape.shape = collision_shape.shape.duplicate()


func _process(delta):
	
	var camera: Camera3D
	
	if Engine.is_editor_hint():
		camera = EditorInterface.get_editor_viewport_3d().get_camera_3d()
	else:
		camera = get_viewport().get_camera_3d()
	if camera:
		var dir = camera.global_position
		dir = to_local(dir)
		dir.y = 0
		dir = dir.normalized()
		collision_shape.shape.plane = Plane(dir.x,0,dir.z,0)


func set_length(new_length : float) -> void:
	length = new_length
	length = max(new_length,0.01)
	_update_mesh()


func set_width(new_width : float) -> void:
	width = clampf(new_width,0.01,length / 4)
	_update_mesh()


func set_color(new_color : Color) -> void:
	color = new_color
	_update_mesh()


func _update_mesh() -> void:
	if !is_node_ready(): await ready
	var mesh_stem = instance_stem.mesh
	var mesh_head = instance_head.mesh
	
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
	collision_shape.debug_color = color
