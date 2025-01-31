@tool
extends Camera3D
class_name FeedbackCamera3D
## A camera but notifies if its transform changes

signal transform_changed

func _ready() -> void:
	set_notify_transform(true)

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		transform_changed.emit()