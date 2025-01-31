extends Node3D

@export var zoom : float = 5.0 : set = set_zoom
var final_zoom : float :
	set(new): 
		final_zoom = new
		$FeedbackCamera3D.position.z = final_zoom

const SENSITIVITY = 0.007

func _ready() -> void:
	final_zoom = zoom

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			rotation -= Vector3(event.relative.y, event.relative.x, 0) * SENSITIVITY
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom /= 1.1
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom *= 1.1

func set_zoom(new: float):
	zoom = clampf(new, 0.1, 10000)
	get_tree().create_tween().set_trans(Tween.TRANS_LINEAR).tween_property(self, "final_zoom", zoom, 0.1)