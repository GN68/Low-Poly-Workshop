extends Resource
class_name LPWProjectFile

@export var name : String = "New Project"
@export var path : String
@export var _version : String = "1.0.0"
@export var _unsaved_changes : bool
@export var elements : Array

func _init() -> void:
	_version = ProjectSettings.get_setting("application/config/version", "0.0.0")