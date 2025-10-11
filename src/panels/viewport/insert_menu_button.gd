extends MenuButton

func _ready() -> void:
	var popup := get_popup()
	for lpw_class in Registry.get_lpw_object_classes_list():
		popup.add_item(lpw_class)
	
	popup.id_pressed.connect(_on_lpw_class_selected)


func _on_lpw_class_selected(index: int) -> void:
	print(index)
	LPWEditor.create_mesh()