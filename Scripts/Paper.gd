class_name Paper extends Node3D

@onready var animation_player := $AnimationPlayer as AnimationPlayer

@export var fold_actions: Array[FoldAction] = []

var current_step = 0

func _ready() -> void:
	hide_all_handles()

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
			var distance = mouse_position.distance_squared_to(global_position+action.handle_position)
			if distance <= min_distance:
				min_distance = distance
				min_action = action
	return min_action

func hide_all_handles() -> void:
	for action in fold_actions:
		(get_node(action.handle_path) as Node3D).visible = false
