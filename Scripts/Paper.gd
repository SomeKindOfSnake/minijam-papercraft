class_name Paper extends Node3D

const unit_scale = .54

var effective_scale = 1

var paper_materials: Array[ShaderMaterial] = [
	preload("res://Materials/Paper/Paper_01.tres"),
	preload("res://Materials/Paper/Paper_02.tres"),
	preload("res://Materials/Paper/Paper_03.tres")
]

@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var game := get_tree().root.get_node("Game") as Game

@export var paper_mesh: MeshInstance3D
@export var fold_actions: Array[FoldAction] = []
@export var rune: Node3D
@export var crystal: Pickable

@export var stamps: Array[Stamp] = []
@export var usable_stamp: int

var current_step = 0

var stamp_being_used = false
var stamp_used = false

func _ready() -> void:
	hide_all_handles()
	effective_scale = (get_parent() as Node3D).scale.x * unit_scale
	paper_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_DOUBLE_SIDED

func get_material() -> ShaderMaterial:
	return paper_mesh.get_surface_override_material(0)

func set_material(material: ShaderMaterial):
	paper_mesh.set_surface_override_material(0, material)

func pick_random_material() -> void:
	var new_material := (paper_materials.pick_random() as ShaderMaterial).duplicate()
	var base_color = Color(randf(), randf(), randf())
	new_material.set_shader_parameter("ColorParameter", base_color)
	new_material.set_shader_parameter("RuneAmount", 0)
	paper_mesh.set_surface_override_material(0, new_material)

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
	if rune != null and crystal != null and not stamp_being_used:
		var material = get_material()
		if crystal.is_carried:
			var distance = crystal.global_position.distance_squared_to(rune.global_position)
			if distance < 3:
				material.set_shader_parameter("RuneAmount", 1.0)
			elif distance >= 3 and distance < 4:
				material.set_shader_parameter("RuneAmount", remap(distance, .5**2, 1**2, 1, 0))
			else:
				material.set_shader_parameter("RuneAmount", 0.0)
		else:
			material.set_shader_parameter("RuneAmount", 0.0)
		
		if stamps[usable_stamp].global_position.distance_squared_to(rune.global_position) < 0.5 and not stamps[usable_stamp].is_carried:
			stamps[usable_stamp].animation_end.connect(_on_stamp_animation_ends)
			stamps[usable_stamp].use_stamp()
			stamp_being_used = true
			stamp_used = true
			game.switch_tutorial_to_special()

func _on_stamp_animation_ends():
	stamp_being_used = false
	stamps[usable_stamp].animation_end.disconnect(_on_stamp_animation_ends)
