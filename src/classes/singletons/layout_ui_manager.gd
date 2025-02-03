@tool
extends Control
class_name LayoutUIManager
## The class that manages the layouts being shown in the UI

@export var layouts: LayoutCollection = LayoutCollection.new() : set = set_layout_collection
@export var current_layout: Layout : set = set_current_layout

var should_save_layout = false

const PATH_LAYOUTS = "user://layouts.tres"
var ContentPanelScene = preload("res://panels/template/content_panel.tscn")


func _init() -> void:
	Registry.LayoutUIManager = self
	if FileAccess.file_exists(PATH_LAYOUTS):
		load_layout_collection()
	else:
		layouts = LayoutCollection.new()
		save_layout_collection()
	layouts.collection_changed.connect(save_layout_collection)


func _ready() -> void:
	set_current_layout(layouts.collection[0])


## Sets the current layout, assuming it exists in the layout collection.
func set_current_layout(new_layout: Layout) -> void:
	current_layout = new_layout
	load_current_layout()

## Sets the existing layouts
func set_layout_collection(new_layouts : LayoutCollection) -> void:
	layouts = new_layouts


## Saves the current state of the UI Layout to a layout resource.
func save_layout() -> void:
	_collect_layout(get_child(0), current_layout.tree)
	print(current_layout.tree)
	save_layout_collection()


func _collect_layout(layout, data: Dictionary) :
	if layout is ContentPanel:
		if layout.current_panel is ContentPanelIdentity:
			data.clear()
			data["type"] = layout.current_panel.name
	elif layout is SplitterContainer:
		data.clear()
		data["is_vertical"] = layout.is_vertical
		data["split"] = layout.split
		data["A"] = {}
		data["B"] = {}
		_collect_layout(layout.get_child(0), data["A"])
		_collect_layout(layout.get_child(1), data["B"])


func load_current_layout() -> void:
	for child in get_children(): child.queue_free()
	_generate_layout(self,current_layout.tree)


func _generate_layout(node: Control,data: Dictionary) -> void:
	if data.has("A"):
		var splitter = SplitterContainer.new()
		node.add_child(splitter)
		_generate_layout(splitter, data["A"])
		_generate_layout(splitter, data["B"])
		splitter.split = data["split"]
		splitter.is_vertical = data["is_vertical"]
		splitter.layout_changed.connect(_on_layout_change)
		
		if node == self: # if this is the root node.
			splitter.anchor_left = 0
			splitter.anchor_right = 1
			splitter.anchor_top = 0
			splitter.anchor_bottom = 1
	else:
		var panel: ContentPanel = ContentPanelScene.instantiate()
		
		if data.has("type") and Registry.has_panel(data["type"]):
			panel.current_panel = Registry.get_panel(data["type"])
		node.add_child(panel)
		if node == self: # if this is the root node.
			panel.anchor_left = 0
			panel.anchor_right = 1
			panel.anchor_top = 0
			panel.anchor_bottom = 1
		panel.layout_changed.connect(_on_layout_change)


func _on_layout_change():
	should_save_layout = true

func _process(delta: float) -> void:
	if should_save_layout:
		should_save_layout = false
		save_layout()

## Loads file state of the layout collection
func load_layout_collection() -> void:
	layouts = ResourceLoader.load(PATH_LAYOUTS, "LayoutCollection")
	current_layout = layouts.collection[0]


## Save the current state of the layout collection
func save_layout_collection() -> void:
	var ok = ResourceSaver.save(layouts, PATH_LAYOUTS)
	print("Saved layout collection, err: ", ok)
