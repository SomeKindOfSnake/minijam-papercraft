extends Control

var left_button_pressed = false
var last_mouse_position = Vector2(-1, -1)

func _ready() -> void:
	var game := get_tree().root.get_node("Game") as Game
	
	for button in $VBoxContainer.get_children():
		(button as PhoneButton).button_released.connect(game.on_button_released)

func on_mouse_move(mouse_position: Vector2):
	last_mouse_position = mouse_position

func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not left_button_pressed:
		left_button_pressed = true
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and left_button_pressed:
		left_button_pressed = false
		for button in $VBoxContainer.get_children():
			(button as PhoneButton).on_mouse_button_release(last_mouse_position)
	
	for button in $VBoxContainer.get_children():
		(button as PhoneButton).update_button_colors(last_mouse_position, left_button_pressed)
