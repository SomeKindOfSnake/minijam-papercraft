class_name Pickable extends RigidBody3D

signal picked_up
signal dropped

@onready var game := get_tree().root.get_node("Game") as Game

@export var base_node: Node3D
@export var base_collision_shape: CollisionShape3D

@export var pickable_base: PickableBase
@export var respawn_base: Node3D

@export var base_scale: float
@export var picked_scale: float

@export var rotation_impulse_range: Vector3

var is_carried = false
var in_socket = true
var plane = Plane(Vector3.UP, Vector3(0, 1, 0))

func _ready() -> void:
	input_event.connect(_on_input_event)
	
	if pickable_base != null and global_position.distance_to(pickable_base.global_position) < 1 and pickable_base.request_base(self):
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
		gravity_scale = 1
		if respawn_base:
			basis = respawn_base.global_basis
			global_position = respawn_base.global_position
		else:
			basis = pickable_base.global_basis
			global_position = pickable_base.global_position
			base_node.scale = Vector3.ONE * base_scale
			base_collision_shape.scale = Vector3.ONE * base_scale
			in_socket = true
		is_carried = false

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_released("click") and not is_carried:
		if not game or game.request_picking(self):
			pickable_base.unrequest_base(self)
			is_carried = true
			in_socket = false
			picked_up.emit()
			gravity_scale = 0
			base_node.scale = Vector3.ONE * picked_scale
			base_collision_shape.scale = Vector3.ONE * picked_scale
	elif event.is_action_released("click") and is_carried:
		if not game or game.request_unpicking(self):
			is_carried = false
			gravity_scale = 1
			dropped.emit()
			if global_position.distance_to(pickable_base.global_position) < 1 and pickable_base.request_base(self):
				basis = pickable_base.global_basis
				global_position = pickable_base.global_position
				base_node.scale = Vector3.ONE * base_scale
				base_collision_shape.scale = Vector3.ONE * base_scale
				in_socket = true
			else:
				apply_torque(rotation_impulse_range*randf_range(-1, 1))

func _physics_process(delta: float) -> void:
	if global_position.length_squared() > 5**2:
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
		gravity_scale = 1
		if respawn_base:
			basis = respawn_base.global_basis
			global_position = respawn_base.global_position
		else:
			basis = pickable_base.global_basis
			global_position = pickable_base.global_position
			base_node.scale = Vector3.ONE * base_scale
			base_collision_shape.scale = Vector3.ONE * base_scale
			in_socket = true
		is_carried = false
		if game:
			game.request_unpicking(self)
	
	if is_carried:
		var mouse_position = get_viewport().get_mouse_position()
		var camera = get_viewport().get_camera_3d()
		var origin = camera.project_ray_origin(mouse_position)
		var end = origin + camera.project_ray_normal(mouse_position) * 1000
		var new_crystal_position = plane.intersects_ray(origin, end-origin)
		
		position += (new_crystal_position - position) * .3
		quaternion += (Quaternion(Vector3.UP, 0)-quaternion) * .3
