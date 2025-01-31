class_name OrigamiMaker extends Node3D

var default_crane_scene := preload("res://Scenes/Paper/Crane/Crane_1_Correct.tscn") as PackedScene

@onready var origami_holder := $OrigamiHolder as Node3D
@onready var camera := $Camera3D as Camera3D

var current_paper: Paper = null
var current_fold_action: FoldAction = null

var progression = 0.0

var left_mouse_button_pressed = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		current_paper = default_crane_scene.instantiate() as Paper
		origami_holder.add_child(current_paper)

func _process(delta: float) -> void:
	if origami_holder.get_child_count() > 0:
		var space_state = get_world_3d().direct_space_state
		var mouse_position_on_screen = get_viewport().get_mouse_position()
		var origin = camera.project_ray_origin(mouse_position_on_screen)
		var end = origin + camera.project_ray_normal(mouse_position_on_screen) * 1000
		var query = PhysicsRayQueryParameters3D.create(origin, end)
		var result = space_state.intersect_ray(query)
		
		var mouse_position = Vector3.ZERO
		
		if result:
			mouse_position = result.position
			
			if not left_mouse_button_pressed:
				current_fold_action = current_paper.get_closest_fold_action(mouse_position)
				current_paper.hide_all_handles()
				if current_fold_action != null:
					(current_paper.get_node(current_fold_action.handle_path) as Node3D).visible = true
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not left_mouse_button_pressed:
			left_mouse_button_pressed = true
			if current_fold_action != null:
				current_paper.select_animation(current_fold_action.animation_result)
				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and left_mouse_button_pressed:
			left_mouse_button_pressed = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			if progression > 0 and current_paper.animation_player.current_animation != null:
				var tween = create_tween()
				tween.tween_method(current_paper.seek, progression, 0, .5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
				tween.play()
		
		if result:
			if left_mouse_button_pressed and current_fold_action != null:
				var selected_corner_to_mouse = mouse_position-current_fold_action.handle_position
				progression = selected_corner_to_mouse.dot(current_fold_action.movement.normalized())/current_fold_action.movement.length()
				current_paper.seek(progression)
				if progression >= 1:
					progression = 0
					current_paper.current_step += 1
					current_fold_action = null
					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
					current_paper.hide_all_handles()
