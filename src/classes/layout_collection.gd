extends Resource
class_name LayoutCollection


@export var collection : Array[Layout] = [] : set = set_collection


signal collection_changed


func set_collection(new_layouts : Array[Layout]) -> void:
	collection = new_layouts
	collection_changed.emit()


## Creates a new empty layout
func new_layout() -> void:
	collection.append(Layout.new())
	collection_changed.emit()


## Deletes the layout at the given index
func delete_layout_at(index : int) -> void:
	collection.remove_at(index)
	collection_changed.emit()


func delete_layout(layout : Layout) -> void:
	collection.erase(layout)
	collection_changed.emit()


func swap_layouts(index_a : int, index_b : int) -> void:
	if index_a != index_b:
		var temp = collection[index_a]
		collection[index_a] = collection[index_b]
		collection[index_b] = temp
		collection_changed.emit()