@tool
extends FeedbackCamera3D
class_name MimicCamera3D

@export var target_camera : FeedbackCamera3D : set = set_target_camera

func _update_tranform() -> void:
	global_transform = target_camera.global_transform

func set_target_camera(camera : FeedbackCamera3D) -> void:
	target_camera = camera
	camera.transform_changed.connect(_update_tranform)