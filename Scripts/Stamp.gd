class_name Stamp extends Pickable

signal animation_end

var used = false

var rotation_force_direction = Vector3.LEFT

func use_stamp():
	if not used:
		input_event.disconnect(_on_input_event)
		gravity_scale = 0
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
		used = true
		var tween = create_tween()
		tween.tween_interval(1.0)
		tween.tween_property(self, "linear_velocity", Vector3.DOWN*.5, .1)
		tween.play()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if used and visible:
		apply_torque(rotation_force_direction*delta*100)
		rotation_force_direction = rotation_force_direction.rotated(Vector3.UP, PI*3.0/180.0)
		
		if linear_velocity.length() > .05:
			base_collision_shape.scale -= Vector3.ONE*.5*delta
			base_node.scale -= Vector3.ONE*.5*delta
			if base_collision_shape.scale.x < 0.01:
				animation_end.emit()
				visible = false
				global_position = Vector3(100, 0, 0)
				var tween = create_tween()
				tween.tween_interval(5)
				tween.tween_callback(func(): 
					visible = true
					used = false
					input_event.connect(_on_input_event)
				)
				tween.play()
