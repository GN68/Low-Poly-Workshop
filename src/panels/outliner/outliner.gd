extends Tree

const DRAG_THRESHOLD_DISTANCE = 20


func _ready() -> void:
	hide_root = true
	create_item() # this is the root node
	update_tree()
	
	LPWEditor.drag_started.connect(_drag_started)
	LPWEditor.drag_ended.connect(_drag_ended)

# TODO: Control._get_drop_data()

func update_tree():
	get_root().free()
	_tree_update()


## Generates the tree recursively
func _tree_update(node: Node = LPWEditor.current_workspace, parent: TreeItem = null):
	for child in node.get_children():
		var item: TreeItem = create_item(parent)
		item.set_text(0, child.name)
		item.set_metadata(0,child)
		_tree_update(child, item)


func _drag_started(data: Variant):
	drop_mode_flags = DropModeFlags.DROP_MODE_INBETWEEN + DropModeFlags.DROP_MODE_ON_ITEM


func _drag_ended(data: Variant):
	drop_mode_flags = DropModeFlags.DROP_MODE_DISABLED



func _get_drag_data(at_position: Vector2) -> Node:
	var item: TreeItem = get_item_at_position(at_position)
	var node: Node = item.get_metadata(0)
	
	var btn = Button.new()
	btn.text = node.name
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn.flat = true
	#get_theme_constant("v_separation")
	btn.size.x = size.x
	set_drag_preview(btn)
	
	LPWEditor.drag_started.emit(node)
	return node

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
	LPWEditor.drag_ended.emit(data)
	var item: TreeItem = get_item_at_position(at_position)
	if item:
		var node: Node = item.get_metadata(0)
		if data is Node:
			if data != node and !data.is_ancestor_of(node):
				data.reparent(node)
				update_tree()
