class_name PhoneButton extends Button

signal button_released(button_name: String)

func update_button_colors(mouse_position: Vector2, left_button_pressed: bool):
	var rect := get_global_rect() as Rect2
	if rect.has_point(mouse_position):
		if left_button_pressed:
			modulate = Color.BLUE
		else:
			modulate = Color.RED
	else:
		modulate = Color.WHITE

func on_mouse_button_release(mouse_position: Vector2):
	var rect := get_global_rect() as Rect2
	if rect.has_point(mouse_position):
		button_released.emit(name)
