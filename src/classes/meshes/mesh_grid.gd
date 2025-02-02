@tool
extends Node3D
class_name Grid


var camera : Camera3D
@onready var base_mesh : MeshInstance3D = MeshInstance3D.new()
var plane : Plane

@export var radius : float = 50.0
@export var minor : float = 0.1
@export var major : int = 5

@export_group("Material")
var material_base : Material

var material : ShaderMaterial


func _ready() -> void:
	material = ShaderMaterial.new()
	material.shader = load("res://shaders/grid.gdshader")
	_generate_mesh()
	
	base_mesh.mesh.surface_set_material(0, material)
	
	set_notify_transform(true)
	add_child(base_mesh)
	update_grid()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		camera = EditorInterface.get_editor_viewport_3d(0).get_camera_3d()
	else:
		camera = get_viewport().get_camera_3d()
	if camera:
		update_grid()
		update_plane()


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		update_plane()
		update_grid()


func update_plane():
	plane = Plane(global_basis.y, global_position)


func update_grid():
	pass
	# TODO: convert to GPU
	# if !camera: return
	# 
	# var projected_pos = plane.project(camera.global_position)
	# 
	# # Scale the grid to seamlesly match minor grid to major grid
	# var dist = projected_pos.distance_to(camera.global_position) * 2
	# var s = 1
	# for i in range(10):
	# 	if dist > major:
	# 		s *= major
	# 		dist /= major
	# base_mesh.scale = Vector3(s,s,s)
	# material.set_shader_parameter("alpha",remap(dist,major,0, 0,0.1))
	# material_minor.set_shader_parameter("alpha", 0.1)
	# 
	# 
	# # Move the grid to the camera
	# projected_pos = to_local(projected_pos)
	# projected_pos.x = snappedf(projected_pos.x, major*minor*s)
	# projected_pos.z = snappedf(projected_pos.z, major*minor*s)
	# base_mesh.position = Vector3(projected_pos.x,0,projected_pos.z)
	

func _get_floor(x: float) -> float:
	return floor(x)

func _place_stripes(st: SurfaceTool, step: float, color: Color = Color(0.5,0.5,0.5)):
	for x in Utils.rangef(-radius,radius,step):
		var s = sqrt(1-clamp(x/(radius),-1,1)**2.0)
		var is_major = (fmod(abs(x),major) == 0)
		if !is_major:
			pass
		st.set_color(Color.BLACK)
		st.add_vertex(Vector3(x,0,-radius*s))
		st.set_color(Color(s,s,s) * color)
		st.add_vertex(Vector3(x,0,0))
		st.add_vertex(Vector3(x,0,0))
		st.set_color(Color.BLACK)
		st.add_vertex(Vector3(x,0,radius*s))
	
	for z in Utils.rangef(-radius,radius,step):
		var s = sqrt(1-clamp(z/(radius),-1,1)**2.0)
		var is_major = (fmod(abs(z),major) == 0)
		if !is_major:
			pass
		st.set_color(Color.BLACK)
		st.add_vertex(Vector3(-radius*s,0,z))
		st.set_color(Color(s,s,s) * color)
		st.add_vertex(Vector3(0,0,z))
		st.add_vertex(Vector3(0,0,z))
		st.set_color(Color.BLACK)
		st.add_vertex(Vector3(radius*s,0,z))

func _generate_mesh():
	var st = SurfaceTool.new()
	# Minor grid lines
	st.begin(Mesh.PRIMITIVE_LINES)
	st.set_normal(Vector3.UP)
	
	_place_stripes(st, minor,Color(0.05,0.05,0.05))
	_place_stripes(st, major,Color(0.1,0.1,0.1))
	
	var mesh = st.commit()	
	
	base_mesh.mesh = mesh
