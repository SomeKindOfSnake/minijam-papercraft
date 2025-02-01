class_name PhoneButton extends Button

signal button_released(button_name: String)

@onready var style_box_texture := get("theme_override_styles/normal") as StyleBoxTexture

func update_button_colors(mouse_position: Vector2, left_button_pressed: bool):
	var rect := get_global_rect() as Rect2
	if rect.has_point(mouse_position):
		if left_button_pressed:
			style_box_texture.modulate_color = Color("#396350")
		else:
			style_box_texture.modulate_color = Color("#5f8a76")
	else:
		style_box_texture.modulate_color = Color("#74a68f")

func on_mouse_button_release(mouse_position: Vector2):
	var rect := get_global_rect() as Rect2
	if rect.has_point(mouse_position):
		button_released.emit(name)
