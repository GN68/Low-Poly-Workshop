@tool
class_name SplitterContainer
extends Container


@export var is_vertical : bool = false : set = set_is_vertical
@export var split : float : set = set_split
@onready var slider = Button.new()
@onready var half = SLIDER_THICKNESS/2


const SLIDER_THICKNESS : float = 8.0
const MARGIN : float = 2.0
const MAX_SPLIT_WIDTH : float = 64


signal layout_changed


func _ready():
	sort_children.connect(_sort_children)
	slider.flat = true
	add_child(slider)
	
	slider.gui_input.connect(_on_slider_gui_input)
	slider.button_up.connect(_on_slider_release)

func _sort_children():
	if !is_node_ready(): await ready
	
	move_child(slider,get_child_count()-1)
	
	slider.anchor_left = 0
	slider.anchor_right = 1
	slider.anchor_top = 0
	slider.anchor_bottom = 1
	
	if get_child_count() != 3: return
	var a = get_child(0)
	var b = get_child(1)
	if !is_vertical:
		a.anchor_left = 0
		a.anchor_right = 1
		a.anchor_top = 0
		a.anchor_bottom = split

		b.anchor_left = 0
		b.anchor_right = 1
		b.anchor_top = split
		b.anchor_bottom = 1
		
		b.offset_left = 0
		b.offset_right = 0
		b.offset_bottom = 0
		b.offset_top = MARGIN
		
		a.offset_left = 0
		a.offset_right = 0
		a.offset_bottom = -MARGIN
		a.offset_top = 0
		
		slider.offset_top = -half
		slider.offset_bottom = half
		slider.anchor_top = split
		slider.anchor_bottom = split
	else:
		a.anchor_top = 0
		a.anchor_bottom = 1
		a.anchor_left = 0
		a.anchor_right = split
		
		b.anchor_top = 0
		b.anchor_bottom = 1
		b.anchor_left = split
		b.anchor_right = 1
		
		b.offset_left = MARGIN
		b.offset_right = 0
		b.offset_bottom = 0
		b.offset_top = 0
		
		a.offset_left = 0
		a.offset_right = -MARGIN
		a.offset_bottom = 0
		a.offset_top = 0
		
		slider.offset_left = -half
		slider.offset_right = half
		slider.anchor_left = split
		slider.anchor_right = split


func _on_slider_gui_input(event: InputEvent):
	if event is InputEventMouseMotion:
		if slider.button_pressed:
			var shift = event.relative / size
			if is_vertical: split += shift.x
			else: split += shift.y

func _on_slider_release():
	if split == 0: collapse(false)
	if split == 1: collapse(true)
	layout_changed.emit()


func set_split(new: float):
	split = clampf(new,0,1)
	_sort_children()
	

func collapse(side: bool):
	var child
	if side: child = get_child(0)
	else: child = get_child(1)
	
	var parent = get_parent()
	var order = self.get_index()
	parent.remove_child(self)
	remove_child(child)
	parent.add_child(child)
	parent.move_child(child, order)
	
	child.anchor_bottom = anchor_bottom
	child.anchor_top = anchor_top
	child.anchor_left = anchor_left
	child.anchor_right = anchor_right
	
	child.offset_bottom = offset_bottom
	child.offset_top = offset_top
	child.offset_left = offset_left
	child.offset_right = offset_right
	
	queue_free()


func set_is_vertical(new: bool):
	is_vertical = new
	_sort_children()
