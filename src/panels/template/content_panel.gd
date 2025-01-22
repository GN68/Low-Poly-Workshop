class_name ContentPanel
extends Panel

@export var current_panel : ContentPanelIdentity : set = set_current_panel


var is_splitting = false
var is_split_vertical 
var split_value: float

const SPLIT_THRESHOLD = 64

@onready var split1 = $SplitPreview/Split1
@onready var split2 = $SplitPreview/Split2


func _on_split_button_input(event:InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				if not is_splitting:
					is_splitting = true
					$SplitPreview.visible = true
					get_tree().process_frame.connect(_split_preview)
			else:
				if is_splitting:
					is_splitting = false
					$SplitPreview.visible = false
					get_tree().process_frame.disconnect(_split_preview)
					var rpos = get_global_rect()
					if is_split_vertical:
						if split_value * rpos.size.x < SPLIT_THRESHOLD or (1-split_value) * rpos.size.x < SPLIT_THRESHOLD: print("a"); return
					else:
						if split_value * rpos.size.y < SPLIT_THRESHOLD or (1-split_value) * rpos.size.y < SPLIT_THRESHOLD: print("a"); return
					split(split_value, is_split_vertical)


func set_current_panel(new: ContentPanelIdentity):
	if new is ContentPanelIdentity:
		current_panel = new
		if !is_node_ready(): await ready
		for child in $Content.get_children():
			child.queue_free()
		$Content.add_child(new.content_panel.instantiate())


func split(split_at: float, is_split_vertical: bool):
	var splitter = SplitterContainer.new()
	splitter.is_vertical = is_split_vertical
	var parent = get_parent()
	var order = self.get_index()
	var clone = self.duplicate()
	parent.remove_child(self)
	parent.add_child(splitter)
	parent.move_child(splitter, order)
	
	splitter.anchor_bottom = anchor_bottom
	splitter.anchor_top = anchor_top
	splitter.anchor_left = anchor_left
	splitter.anchor_right = anchor_right
	
	splitter.offset_bottom = 0
	splitter.offset_top = 0
	splitter.offset_left = 0
	splitter.offset_right = 0
	
	splitter.add_child(clone)
	splitter.add_child(self)
	splitter.split = split_at


func _split_preview():
	var mpos = get_global_mouse_position()
	var rpos = get_global_rect()
	var anchor_pos = Vector2(
		remap(mpos.x, rpos.position.x, rpos.end.x, 0, 1),
		remap(mpos.y, rpos.position.y, rpos.end.y, 0, 1)
	)
	is_split_vertical = abs(anchor_pos.x-0.5) < abs(anchor_pos.y-0.5)
	
	if is_split_vertical:
		split_value = anchor_pos.x
		split1.anchor_top = 0
		split1.anchor_left = 0
		split1.anchor_right = anchor_pos.x
		split1.anchor_bottom = 1
		
		split2.anchor_top = 0
		split2.anchor_left = anchor_pos.x
		split2.anchor_right = 1
		split2.anchor_bottom = 1
		
	else:
		split_value = anchor_pos.y
		split1.anchor_top = 0
		split1.anchor_left = 0
		split1.anchor_right = 1
		split1.anchor_bottom = anchor_pos.y
		
		split2.anchor_top = anchor_pos.y
		split2.anchor_left = 0
		split2.anchor_right = 1
		split2.anchor_bottom = 1
