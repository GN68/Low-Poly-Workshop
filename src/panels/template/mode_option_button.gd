extends OptionButton

func _ready() -> void:
	clear()
	for i in range(Registry.panels.size()):
		var identity = Registry.panels[i]
		add_icon_item(identity.icon,identity.name,i)
	item_selected.connect(_item_selected)


func _item_selected(index: int) -> void:
	var parent = get_parent()
	if parent is ContentPanel:
		parent.current_panel = Registry.panels[index]
	else:
		push_error("Parent is not a ContentPanel")