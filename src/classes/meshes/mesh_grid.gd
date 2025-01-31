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

var material_major : ShaderMaterial
var material_minor : ShaderMaterial


func _ready() -> void:
	material_base = ShaderMaterial.new()
	material_base.shader = load("res://shaders/grid.gdshader")
	_generate_mesh()
	
	material_major = material_base.duplicate()
	material_minor = material_base.duplicate()
	
	base_mesh.mesh.surface_set_material(0, material_major)
	base_mesh.mesh.surface_set_material(1, material_minor)
	
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
	if !camera: return
	
	var projected_pos = plane.project(camera.global_position)
	
	# Scale the grid to seamlesly match minor grid to major grid
	var dist = projected_pos.distance_to(camera.global_position) * 2
	var s = 1
	for i in range(10):
		if dist > major:
			s *= major
			dist /= major
	base_mesh.scale = Vector3(s,s,s)
	material_major.set_shader_parameter("alpha",remap(dist,major,0, 0,0.1))
	material_minor.set_shader_parameter("alpha", 0.1)
	
	
	# Move the grid to the camera
	projected_pos = to_local(projected_pos)
	projected_pos.x = snappedf(projected_pos.x, major*minor*s)
	projected_pos.z = snappedf(projected_pos.z, major*minor*s)
	base_mesh.position = Vector3(projected_pos.x,0,projected_pos.z)
	

func _get_floor(x: float) -> float:
	return floor(x)


func _generate_mesh():
	var st = SurfaceTool.new()
	# Minor grid lines
	st.begin(Mesh.PRIMITIVE_LINES)
	
	for x in Utils.rangef(-radius,radius,minor):
		var s = max(sqrt(1-(x/(radius*minor))**2.0),0)
		var is_major = (fmod(abs(x),major) == 0)
		st.set_normal(Vector3.UP)
		if !is_major:
			st.set_color(Color.BLACK)
			st.add_vertex(Vector3(x,0,-minor*radius*s))
			st.set_color(Color(s,s,s))
			st.add_vertex(Vector3(x,0,0))
			st.add_vertex(Vector3(x,0,0))
			st.set_color(Color.BLACK)
			st.add_vertex(Vector3(x,0,minor*radius*s))
	
	for z in Utils.rangef(-radius,radius,minor):
		var s = max(sqrt(1-(z/(radius*minor))**2.0),0)
		var is_major = (fmod(abs(z),major) == 0)
		if !is_major:
			st.set_color(Color.BLACK)
			st.add_vertex(Vector3(-minor*radius*s,0,z))
			st.set_color(Color(s,s,s))
			st.add_vertex(Vector3(0,0,z))
			st.add_vertex(Vector3(0,0,z))
			st.set_color(Color.BLACK)
			st.add_vertex(Vector3(minor*radius*s,0,z))
	
	var mesh = st.commit()
	st.begin(Mesh.PRIMITIVE_LINES)
	
	#Major grid lines
	var step = major*minor
	for x in Utils.rangef(-radius,radius,minor):
		var s = max(sqrt(clamp(1-(x/(radius*minor))**2.0,0,1)),0)
		st.set_color(Color.BLACK)
		st.add_vertex(Vector3(x*major,0,-step*radius*s))
		st.set_color(Color(s,s,s))
		st.add_vertex(Vector3(x*major,0,0))
		st.add_vertex(Vector3(x*major,0,0))
		st.set_color(Color.BLACK)
		st.add_vertex(Vector3(x*major,0,step*radius*s))
	
	for z in Utils.rangef(-radius,radius,minor):
		var s = max(sqrt(clamp(1-(z/(radius*minor))**2.0,0,1)),0)
		st.set_color(Color.BLACK)
		st.add_vertex(Vector3(-step*radius*s,0,z*major))
		st.set_color(Color(s,s,s))
		st.add_vertex(Vector3(0,0,z*major))
		st.add_vertex(Vector3(0,0,z*major))
		st.set_color(Color.BLACK)
		st.add_vertex(Vector3(step*radius*s,0,z*major))
	
	mesh = st.commit(mesh)
	
	base_mesh.mesh = mesh
