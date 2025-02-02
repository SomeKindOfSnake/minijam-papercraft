class_name Paper extends Node3D

const unit_scale = .54

var effective_scale = 1

var paper_materials: Array[ShaderMaterial] = [
	preload("res://Materials/Paper/Paper_01.tres"),
	preload("res://Materials/Paper/Paper_02.tres"),
	preload("res://Materials/Paper/Paper_03.tres")
]

@onready var animation_player := $AnimationPlayer as AnimationPlayer

@export var paper_mesh: MeshInstance3D
@export var fold_actions: Array[FoldAction] = []
@export var rune: Node3D
@export var crystal: Crystal

var current_step = 0

func _ready() -> void:
	hide_all_handles()
	effective_scale = (get_parent() as Node3D).scale.x * unit_scale

func get_material() -> Array[ShaderMaterial]:
	if paper_mesh.get_surface_override_material_count() > 1:
		return [
			paper_mesh.get_surface_override_material(0),
			paper_mesh.get_surface_override_material(1),
		]
	else:
		return [
			paper_mesh.get_surface_override_material(0),
		]

func set_material(materials: Array[ShaderMaterial]):
	paper_mesh.set_surface_override_material(0, materials[0])
	if paper_mesh.get_surface_override_material_count() > 1:
		paper_mesh.set_surface_override_material(1, materials[1])

func pick_random_material() -> void:
	var new_material := (paper_materials.pick_random() as ShaderMaterial).duplicate()
	var base_color = Color(randf(), randf(), randf())
	new_material.set_shader_parameter("ColorParameter", base_color)
	new_material.set_shader_parameter("RuneAmount", 0)
	paper_mesh.set_surface_override_material(0, new_material)
	
	if paper_mesh.get_surface_override_material_count() > 1:
		var new_material_back := new_material.duplicate()
		new_material_back.set_shader_parameter("ColorParameter", base_color+Color(.2, .2, .2))
		new_material_back.set_shader_parameter("RuneAmount", 0)
		paper_mesh.set_surface_override_material(1, new_material_back)

func seek(factor: float) -> void:
	animation_player.seek(factor * animation_player.current_animation_length, true)

func select_animation(animation_name: String) -> void:
	play_animation(animation_name)
	animation_player.pause()
	animation_player.seek(0)

func play_animation(animation_name: String) -> void:
	animation_player.play(animation_name)

func get_auto_action() -> FoldAction:
	for action in fold_actions:
		if action.available_step == current_step and action.auto_play:
			return action
	return null

func get_closest_fold_action(mouse_position: Vector3) -> FoldAction:
	var min_distance = .2**2
	var min_action: FoldAction = null
	for action in fold_actions:
		if action.available_step == current_step and has_node(action.handle_path):
			var node := get_node(action.handle_path) as Node3D
			var distance = mouse_position.distance_squared_to(global_position+action.handle_position*effective_scale)
			if distance <= min_distance:
				min_distance = distance
				min_action = action
	return min_action

func hide_all_handles() -> void:
	for action in fold_actions:
		if has_node(action.handle_path):
			(get_node(action.handle_path) as Node3D).visible = false

func _process(delta: float) -> void:
	if rune != null and crystal != null:
		var materials = get_material()
		if crystal.is_carried:
			var distance = crystal.global_position.distance_squared_to(rune.global_position)
			if distance < .5**2:
				materials[0].set_shader_parameter("RuneAmount", 1.0)
				#materials[1].set_shader_parameter("RuneAmount", 1.0)
			elif distance >= .5**2 and distance < 1**2:
				materials[0].set_shader_parameter("RuneAmount", remap(distance, .5**2, 1**2, 1, 0))
				#materials[1].set_shader_parameter("RuneAmount", remap(distance, .5**2, 1**2, 1, 0))
			else:
				materials[0].set_shader_parameter("RuneAmount", 0.0)
				#materials[1].set_shader_parameter("RuneAmount", 0.0)
		else:
			materials[0].set_shader_parameter("RuneAmount", 0.0)
			#materials[1].set_shader_parameter("RuneAmount", 0.0)
