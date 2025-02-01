class_name Paper extends Node3D

const unit_scale = .54

var paper_materials: Array[ShaderMaterial] = [
	preload("res://Materials/Paper/Paper_01.tres"),
	preload("res://Materials/Paper/Paper_02.tres"),
	preload("res://Materials/Paper/Paper_03.tres")
]

@onready var animation_player := $AnimationPlayer as AnimationPlayer

@export var paper_mesh: MeshInstance3D
@export var fold_actions: Array[FoldAction] = []

var current_step = 0

func _ready() -> void:
	hide_all_handles()

func get_material() -> ShaderMaterial:
	return paper_mesh.get_surface_override_material(0)

func set_material(material: ShaderMaterial):
	paper_mesh.set_surface_override_material(0, material)

func pick_random_material() -> void:
	var new_material := (paper_materials.pick_random() as ShaderMaterial).duplicate()
	new_material.set_shader_parameter("ColorParameter", Color(randf(), randf(), randf()))
	paper_mesh.set_surface_override_material(0, new_material)

func seek(factor: float) -> void:
	animation_player.seek(factor * animation_player.current_animation_length, true)

func select_animation(animation_name: String) -> void:
	play_animation(animation_name)
	animation_player.pause()
	animation_player.seek(0)

func play_animation(animation_name: String) -> void:
	animation_player.play(animation_name)

func get_closest_fold_action(mouse_position: Vector3) -> FoldAction:
	var min_distance = .02**2
	var min_action: FoldAction = null
	for action in fold_actions:
		if action.available_step == current_step:
			var node := get_node(action.handle_path) as Node3D
			var distance = mouse_position.distance_squared_to(global_position+action.handle_position*unit_scale)
			if distance <= min_distance:
				min_distance = distance
				min_action = action
	return min_action

func hide_all_handles() -> void:
	for action in fold_actions:
		(get_node(action.handle_path) as Node3D).visible = false
