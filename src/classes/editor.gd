extends Node


@export var layouts: LayoutCollection = LayoutCollection.new() : set = set_layout_collection


const PATH_LAYOUTS = "user://layouts.tres"



func _init() -> void:
	if FileAccess.file_exists(PATH_LAYOUTS):
		layouts = load_layout_collection()
	else:
		layouts = LayoutCollection.new()
		save_layout_collection()


## Sets the existing layouts
func set_layout_collection(new_layouts : LayoutCollection) -> void:
	layouts = new_layouts


## Loads file state of the layout collection
func load_layout_collection() -> LayoutCollection:
	return ResourceLoader.load(PATH_LAYOUTS, "LayoutCollection")


## Save the current state of the layout collection
func save_layout_collection() -> void:
	ResourceSaver.save(layouts, PATH_LAYOUTS)