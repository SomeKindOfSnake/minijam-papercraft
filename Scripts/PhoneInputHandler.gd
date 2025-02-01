class_name PhoneInputHandler extends StaticBody3D

signal mouse_moved_on_phone(mouse_position: Vector2)

@onready var collision_shape := $CollisionShape3D as CollisionShape3D

@export var sub_viewport: SubViewport
@export var camera: Camera3D

var previous_mouse_on_phone_position = Vector2.ZERO
var mouse_on_phone_position = Vector2.ZERO

func _process(delta: float) -> void:
	var space_state = get_world_3d().direct_space_state
	var mouse_position_on_screen = get_viewport().get_mouse_position()
	var origin = camera.project_ray_origin(mouse_position_on_screen)
	var end = origin + camera.project_ray_normal(mouse_position_on_screen) * 1000
	var query = PhysicsRayQueryParameters3D.create(origin, end, int(1 << 1))
	var result = space_state.intersect_ray(query)
	
	if result:
		var phone_plane = Plane(global_transform.basis.y, global_position)
		previous_mouse_on_phone_position = mouse_on_phone_position
		var current_mouse_on_phone_position = phone_plane.project(result.position-global_position)
		current_mouse_on_phone_position = Vector3(global_basis.tdotx(current_mouse_on_phone_position), global_basis.tdoty(current_mouse_on_phone_position), global_basis.tdotz(current_mouse_on_phone_position))
		current_mouse_on_phone_position.x /= (collision_shape.shape as BoxShape3D).size.x * global_basis.get_scale().x ** 2
		current_mouse_on_phone_position.z /= (collision_shape.shape as BoxShape3D).size.z * global_basis.get_scale().x ** 2
		current_mouse_on_phone_position.x += 0.5
		current_mouse_on_phone_position.z += 0.5
		var current_mouse_on_phone_position_2d = Vector2(current_mouse_on_phone_position.x, current_mouse_on_phone_position.z)
		
		if previous_mouse_on_phone_position.distance_squared_to(current_mouse_on_phone_position_2d) > .01**2:
			mouse_on_phone_position = current_mouse_on_phone_position_2d
			mouse_moved_on_phone.emit(Vector2(mouse_on_phone_position.x*sub_viewport.size.x, mouse_on_phone_position.y*sub_viewport.size.y))

func _on_mouse_exited() -> void:
	mouse_moved_on_phone.emit(Vector2(-100, -100))
