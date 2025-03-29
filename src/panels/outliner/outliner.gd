extends Tree

func _ready() -> void:
	var root = create_item()
	hide_root = true
	var child1 = create_item(root)
	var child2 = create_item(root)
	var subchild1 = create_item(child1)
	subchild1.set_text(0, "Subchild1")