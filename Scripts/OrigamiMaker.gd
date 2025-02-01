class_name OrigamiMaker extends Node3D

signal next_step()

const unit_scale = .54

var default_crane_scene := preload("res://Scenes/Paper/Crane/Crane_1_Correct.tscn") as PackedScene

@onready var origami_holder := $OrigamiHolder as Node3D

@export var crystal: Crystal

var current_paper: Paper = null
var current_fold_action: FoldAction = null

var progression = 0.0

var left_mouse_button_pressed = false

func start_crane() -> void:
	current_paper = default_crane_scene.instantiate() as Paper
	current_paper.pick_random_material()
	origami_holder.add_child(current_paper)

func on_action_done() -> void:
	current_paper.current_step += 1
	
	if current_fold_action.increment_tutorial_step:
		next_step.emit()
	
	# if we need to switch at the end
	if current_fold_action.switch_mesh and not current_fold_action.switch_on_click:
		var material := current_paper.get_material()
		current_paper.queue_free()
		current_paper = current_fold_action.new_mesh.instantiate()
		current_paper.set_material(material)
		current_paper.crystal = crystal
		origami_holder.add_child(current_paper)
	
	if current_fold_action.loop_after:
		current_paper.play_animation(current_fold_action.animation_loop_after)
	
	current_fold_action = current_paper.get_auto_action()
	
	if current_fold_action != null:
		current_paper.play_animation(current_fold_action.animation_result)
		var tween = create_tween()
		tween.tween_interval(current_paper.animation_player.current_animation_length)
		tween.tween_callback(on_action_done)
		tween.play()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	current_paper.hide_all_handles()

func _process(delta: float) -> void:
	if origami_holder.get_child_count() > 0:
		var space_state = get_world_3d().direct_space_state
		var mouse_position_on_screen = get_viewport().get_mouse_position()
		var camera = get_viewport().get_camera_3d()
		var origin = camera.project_ray_origin(mouse_position_on_screen)
		var end = origin + camera.project_ray_normal(mouse_position_on_screen) * 1000
		var query = PhysicsRayQueryParameters3D.create(origin, end)
		var result = space_state.intersect_ray(query)
		
		var mouse_position = Vector3.ZERO
		
		if result and (current_fold_action == null or not current_fold_action.auto_play):
			mouse_position = result.position
			
			if not left_mouse_button_pressed:
				current_fold_action = current_paper.get_closest_fold_action(mouse_position)
				current_paper.hide_all_handles()
				if current_fold_action != null:
					(current_paper.get_node(current_fold_action.handle_path) as Node3D).visible = true
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not left_mouse_button_pressed:
			left_mouse_button_pressed = true
			if current_fold_action != null and not current_fold_action.auto_play:
				
				if current_fold_action.switch_mesh and current_fold_action.switch_on_click:
					var materials := current_paper.get_material()
					current_paper.queue_free()
					current_paper = current_fold_action.new_mesh.instantiate()
					current_paper.set_material(materials)
					current_paper.crystal = crystal
					origami_holder.add_child(current_paper)
					current_fold_action = current_paper.fold_actions[current_fold_action.new_fold_action_index]
				
				current_paper.select_animation(current_fold_action.animation_result)
				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and left_mouse_button_pressed:
			left_mouse_button_pressed = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			if progression > 0 and current_paper.animation_player.current_animation != null and current_fold_action != null and not current_fold_action.auto_play:
				var tween = create_tween()
				tween.tween_method(current_paper.seek, progression, 0, .5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
				tween.play()
		
		if result:
			if left_mouse_button_pressed and current_fold_action != null and not current_fold_action.auto_play:
				var selected_corner_to_mouse = mouse_position-current_fold_action.handle_position*unit_scale
				progression = selected_corner_to_mouse.dot(current_fold_action.movement.normalized())/(current_fold_action.movement.length()*unit_scale)
				current_paper.seek(progression)
				if progression >= 1:
					progression = 0
					on_action_done()
