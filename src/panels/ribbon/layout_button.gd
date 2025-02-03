extends Button

@export var layout : Layout : set = set_layout

@onready var popup_menu: PopupMenu = $PopupMenu
@onready var LayoutUIManager = Registry.LayoutUIManager

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and !event.pressed:
		show_menu()

func show_menu():
	popup_menu.visible = true
	var rect = get_global_rect()
	popup_menu.position = Vector2(rect.position.x,rect.position.y+rect.end.y)
	# clamp position to screen
	var screen = get_viewport_rect().size
	popup_menu.position.x = clamp(popup_menu.position.x,0,screen.x-popup_menu.size.x)
	popup_menu.position.y = clamp(popup_menu.position.y,0,screen.y-popup_menu.size.y)


func set_layout(new_layout : Layout) -> void:
	layout = new_layout
	update()


func update():
	if layout:
		text = layout.name
	else:
		text = "???"


## Pops up a rename menu
func rename():
	if layout:
		$RenameLineEdit.placeholder_text = layout.name
		$RenameLineEdit.visible = true
		$RenameLineEdit.text = layout.name
		await get_tree().process_frame
		$RenameLineEdit.grab_focus()

func _on_rename_line_edit_text_submitted(new_text:String) -> void:
	if new_text != "":
		layout.name = new_text
		$RenameLineEdit.visible = false
		update()


func _on_popup_menu_id_pressed(id: int) -> void:
	match id:
		0:
			rename()
		1:
			LayoutUIManager.layouts.delete_layout(layout)
		2:
			if get_index() > 0:
				LayoutUIManager.layouts.swap_layouts(get_index(),get_index()-1)
		3:
			if get_index() < LayoutUIManager.layouts.collection.size()-1:
				LayoutUIManager.layouts.swap_layouts(get_index(),get_index()+1)

func _on_rename_line_edit_focus_exited() -> void:
	$RenameLineEdit.visible = false
