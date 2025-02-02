class_name Pickable extends RigidBody3D

@onready var game := get_tree().root.get_node("Game") as Game

@export var base_place: Node3D

var is_carried = false
var in_socket = true
var plane = Plane(Vector3.UP, Vector3(0, 1, 0))

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_released("click") and not is_carried:
		if not game or game.request_picking(self):
			is_carried = true
			in_socket = false
			gravity_scale = 0
			$AudioStreamPlayer3D.play()
			$crystal.scale = Vector3(.5, .5, .5)
			$CollisionShape3D.scale = Vector3(.5, .5, .5)
	elif event.is_action_released("click") and is_carried:
		if not game or game.request_unpicking(self):
			is_carried = false
			gravity_scale = 1
			if global_position.distance_to(base_place.global_position) < 1:
				basis = base_place.global_basis
				global_position = base_place.global_position
				$crystal.scale = Vector3(1, 1, 1)
				$CollisionShape3D.scale = Vector3(1, 1, 1)
				in_socket = true
			else:
				apply_torque(Vector3(randf_range(-100, 100), randf_range(-10, 10), randf_range(-100, 100)))

func _physics_process(delta: float) -> void:
	if global_position.length_squared() > 5**2:
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
		gravity_scale = 1
		basis = base_place.global_basis
		global_position = base_place.global_position
		$crystal.scale = Vector3(1, 1, 1)
		$CollisionShape3D.scale = Vector3(1, 1, 1)
		in_socket = true
		is_carried = false
	
	if is_carried:
		var mouse_position = get_viewport().get_mouse_position()
		var camera = get_viewport().get_camera_3d()
		var origin = camera.project_ray_origin(mouse_position)
		var end = origin + camera.project_ray_normal(mouse_position) * 1000
		var new_crystal_position = plane.intersects_ray(origin, end-origin)
		
		position += (new_crystal_position - position) * .3
		quaternion += (Quaternion(Vector3.UP, 0)-quaternion) * .3
