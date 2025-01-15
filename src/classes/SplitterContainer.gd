@tool
class_name SplitterContainer
extends Container

@export var is_vertical : bool = false : set = set_is_vertical
@export var split : float : set = set_split
@onready var slider = Button.new()

const SLIDER_THICKNESS : float = 8.0
const MAX_SPLIT_WIDTH : float = 64
@onready var half = SLIDER_THICKNESS/2

func _ready():
	sort_children.connect(_sort_children)
	#slider.flat = true
	add_child(slider)
	
	slider.anchor_left = 0
	slider.anchor_right = 1
	slider.anchor_top = 0
	slider.anchor_bottom = 1
	
	slider.gui_input.connect(_on_slider_gui_input)

func _sort_children():
	if !is_node_ready(): await ready
	
	move_child(slider,3)
	
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

func set_split(new: float):
	if is_vertical: split = clampf(new,MAX_SPLIT_WIDTH/size.x,1-MAX_SPLIT_WIDTH/size.x)
	else: split = clampf(new,MAX_SPLIT_WIDTH/size.y,1-MAX_SPLIT_WIDTH/size.y)
	_sort_children()


func set_is_vertical(new: bool):
	is_vertical = new
	_sort_children()
