extends Camera3D

var base_forward: Vector3
var base_right: Vector3
var base_up: Vector3

var base_rotation: Vector3

func _ready() -> void:
	base_forward = basis.z
	base_right = basis.y
	base_up = basis.x
	base_rotation = rotation

func _process(delta: float) -> void:
	var mouse_position = ((get_viewport().get_mouse_position() / Vector2(get_viewport().size)) - Vector2(0.5, 0.5))*2
	rotation = base_rotation
	rotate(base_right, -(pow(abs(mouse_position.x),1))*sign(mouse_position.x)*0.2)
	rotate(base_up, -(pow(abs(mouse_position.y),1))*sign(mouse_position.y)*0.2)
