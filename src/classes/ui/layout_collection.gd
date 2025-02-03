extends Resource
class_name LayoutCollection


@export var collection : Array[Layout] = [] : set = set_collection


signal collection_changed


func _call_change():
	collection_changed.emit()

## Removes all connections from its layouts to itself, called before modifying the collection
func _remove_connections() -> void:
	for layout in collection:
		layout.some_property_changed.disconnect(self._call_change)


## Adds connections from its layouts, best called once `_remove_connections()` is called
func _add_connections() -> void:
	for layout in collection:
		layout.some_property_changed.connect(self._call_change)


func set_collection(new_layouts : Array[Layout]) -> void:
	_remove_connections()
	collection = new_layouts
	_add_connections()
	collection_changed.emit()


## Creates a new empty layout
func new_layout() -> void:
	_remove_connections()
	collection.append(Layout.new())
	_add_connections()
	collection_changed.emit()


## Deletes the layout at the given index
func delete_layout_at(index : int) -> void:
	_remove_connections()
	collection.remove_at(index)
	_add_connections()
	collection_changed.emit()


func delete_layout(layout : Layout) -> void:
	_remove_connections()
	collection.erase(layout)
	_add_connections()
	collection_changed.emit()


func swap_layouts(index_a : int, index_b : int) -> void:
	if index_a != index_b:
		var temp = collection[index_a]
		collection[index_a] = collection[index_b]
		collection[index_b] = temp
		collection_changed.emit()