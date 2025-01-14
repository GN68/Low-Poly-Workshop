@tool
class_name SplitterContainer
extends Container

@export var is_vertical : bool = false : set = set_is_vertical
@export var split : float

func _ready():
	sort_children.connect(_sort_children)

func _sort_children():
	if get_child_count() != 2: return
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
	else:
		a.anchor_top = 0
		a.anchor_bottom = 1
		a.anchor_left = 0
		a.anchor_right = split
		
		b.anchor_top = 0
		b.anchor_bottom = 1
		b.anchor_left = split
		b.anchor_right = 1



func set_split(new: float):
	split = new
	_sort_children()


func set_is_vertical(new: bool):
	is_vertical = new
	_sort_children()