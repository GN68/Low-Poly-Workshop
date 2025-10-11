@abstract
class_name LPWObject extends Node3D


## Packs data from the object into a dictionary
@abstract
func pack_data(data) -> Dictionary


## Unpacks data from a dictionary into the object
@abstract
func unpack_data(data) -> void