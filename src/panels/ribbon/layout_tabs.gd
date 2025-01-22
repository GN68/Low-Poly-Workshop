extends HBoxContainer


@onready var layout_button = preload("res://panels/ribbon/layout_button.tscn")


func _ready() -> void:
	LPWEditor.layouts.collection_changed.connect(update_tabs)
	update_tabs()

func update_tabs() -> void:
	for child in $LayoutButtons.get_children():
		child.queue_free()
	
	for layout in LPWEditor.layouts.collection:
		var button = layout_button.instantiate()
		button.layout = layout
		button.text = layout.name
		button.theme_type_variation = "LayoutButtonTab"
		$LayoutButtons.add_child(button)


func _on_new_layout_button_pressed() -> void:
	LPWEditor.layouts.new_layout()