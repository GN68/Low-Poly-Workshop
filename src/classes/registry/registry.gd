extends Node


@export var panels : Array[ContentPanelIdentity]
@export var LayoutUIManager: LayoutUIManager


func _ready() -> void:
	for panel in panels:
		_panels_name_lookup[panel.name] = panel

var _panels_name_lookup = {}


## Gets a panel identity by its name.
func get_panel(name: String) -> ContentPanelIdentity:
	return _panels_name_lookup[name]


## Checks if a panel exists by its name.
func has_panel(name: String) -> bool:
	return _panels_name_lookup.has(name)
