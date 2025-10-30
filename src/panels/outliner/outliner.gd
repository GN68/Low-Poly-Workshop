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
		if child is LPWObject:
			var item: TreeItem = create_item(parent)
			item.set_text(0, child.name)
			item.set_icon(0, get_theme_icon(child.get_icon_name(),"Icons"))
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
		var new_parent_node: Node = item.get_metadata(0)
		if data is Node:
			if (data != new_parent_node # if new parent is not itself
			and !data.is_ancestor_of(new_parent_node) # new parent is not an ancestor of the node.
			and data.get_parent() != new_parent_node): # new parent is not the parent of the node already
				# the node with the given name already exists
				# find a name that does not exist
				if new_parent_node.has_node(NodePath(data.name)):
					var no_number_name = data.name.rstrip("0123456789")
					for i in range(2,1000):
						var new_name = no_number_name + str(i)
						if !new_parent_node.has_node(NodePath(new_name)):
							data.name = new_name
							break
				
				data.reparent(new_parent_node)
				update_tree()
