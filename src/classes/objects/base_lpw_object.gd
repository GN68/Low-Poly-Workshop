@abstract
class_name LPWObject extends Node3D



## Returns the icon name for the object
@abstract
func get_icon_name() -> String


## Packs data from the object into a dictionary
@abstract
func pack_data(data) -> Dictionary


## Unpacks data from a dictionary into the object
@abstract
func unpack_data(data) -> void