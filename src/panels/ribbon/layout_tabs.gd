extends HBoxContainer


@onready var layout_button = preload("res://panels/ribbon/layout_button.tscn")
@onready var LayroutUIManager = Registry.LayoutUIManager

func _ready() -> void:
	LayroutUIManager.layouts.collection_changed.connect(update_tabs)
	update_tabs()


func update_tabs() -> void:
	for child in $LayoutButtons.get_children():
		child.queue_free()
	
	var i = 0
	for layout in LayroutUIManager.layouts.collection:
		var button: Button = layout_button.instantiate()
		button.layout = layout
		button.toggle_mode = true
		button.text = layout.name
		button.button_pressed = i != 0
		button.theme_type_variation = "LayoutButtonTab"
		button.pressed.connect(_on_layout_button_pressed.bind(layout))
		i += 1
		$LayoutButtons.add_child(button)


func _update_selected():
	for child in $LayoutButtons.get_children():
		if (child.layout != LayroutUIManager.current_layout):
			if !child.button_pressed:
				child.button_pressed = true
		else:
			if child.button_pressed:
				child.button_pressed = false


func _on_layout_button_pressed(layout: Layout) -> void:
	LayroutUIManager.set_current_layout(layout)
	_update_selected()


func _on_new_layout_button_pressed() -> void:
	LayroutUIManager.layouts.new_layout()