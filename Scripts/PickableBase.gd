class_name PickableBase extends Node3D

var current_pickable: Pickable

func request_base(pickable: Pickable) -> bool:
	if current_pickable == null:
		current_pickable = pickable
		return true
	return false

func unrequest_base(pickable: Pickable) -> bool:
	if current_pickable == pickable:
		current_pickable = null
		return true
	return false
