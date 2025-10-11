extends Node


@export var panels : Array[ContentPanelIdentity]
@export var LayoutUIManager: LayoutUIManager
@export var lpw_objects : Dictionary[String,Resource]

func _ready() -> void:
	for panel in panels:
		_panels_name_lookup[panel.name] = panel
	
	# Load LPW Objects
	for definition in ProjectSettings.get_global_class_list():
		if definition.base == "LPWObject":
			lpw_objects[definition.class] = load(definition.path)

var _panels_name_lookup = {}


## Gets a panel identity by its name.
func get_panel(name: String) -> ContentPanelIdentity:
	return _panels_name_lookup[name]


## Checks if a panel exists by its name.
func has_panel(name: String) -> bool:
	return _panels_name_lookup.has(name)


## Returns a list of all LPWObject classes
func get_lpw_object_classes_list() -> Array[String]:
	return lpw_objects.keys()