extends Resource
class_name Layout


signal property_changed(name: String, value: Variant) ## Emitted when a property is changed.
signal some_property_changed ## The same as `property_changed` event, but with no arguments.


@export var name : String = "New Layout" : set = set_layout_name
@export var tree : Dictionary


func set_layout_name(new: String):
	name = new
	property_changed.emit("name", name)
	some_property_changed.emit()


## Sets the current layout tree. Note: the tree should be a nested array of strings. other values will be ignored[br]
## Layout: `{type: String}` or `{A: tree, B: tree, split: float, is_vertical: bool}`.
func set_tree(new: Dictionary):
	tree = new
	if tree == null: tree = {}
	_verify_tree(tree)
	property_changed.emit("tree", tree)
	some_property_changed.emit()


func _verify_tree(tree: Dictionary) -> void:
	if tree.has("type"): # is a panel
		if tree["type"] is not String:
			tree["type"] = null
	else: # is a split
		if tree.has("A"):
			if tree["A"] is Dictionary:
				_verify_tree(tree["A"])

		if tree.has("B"):
			if tree["B"] is Dictionary:
				_verify_tree(tree["B"])
		
		if not tree.has("split"): tree["split"] = 0.5
	if not tree.has("is_vertical"): tree["is_vertical"] = true