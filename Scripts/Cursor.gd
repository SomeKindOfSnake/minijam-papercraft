extends Sprite2D


func _on_static_body_3d_mouse_moved_on_phone(mouse_position: Vector2) -> void:
	position = Vector2(mouse_position.x, mouse_position.y)
