class_name Phone extends Node3D

@onready var static_body_3d := $StaticBody3D as PhoneInputHandler
@onready var tutorial := $SubViewport/Tutorial as Tutorial

@export var phone_closer: Node3D
@export var phone_base: Node3D
@export var crystal: Crystal

var is_close = false
var current_tween: Tween

func start_tutorial(button_name: String):
	tutorial.start_tutorial(button_name)

func next_step():
	tutorial.next_step()

func move_closer():
	if not is_close and not crystal.is_carried:
		if current_tween != null and current_tween.is_running():
			current_tween.stop()
		current_tween = create_tween()
		current_tween.tween_method(lerp_positions, 0.0, 1.0, .3).set_ease(Tween.EASE_IN_OUT)
		current_tween.play()
		is_close = true

func move_away():
	if is_close and not crystal.is_carried:
		if current_tween != null and current_tween.is_running():
			current_tween.stop()
		var tween = create_tween()
		tween.tween_method(lerp_positions, 1.0, 0.0, .3).set_ease(Tween.EASE_IN_OUT)
		tween.play()
		is_close = false

func lerp_positions(factor: float):
	position = lerp(phone_base.position, phone_closer.position, factor)
	basis = lerp(phone_base.basis, phone_closer.basis, factor)

func _on_static_body_3d_mouse_entered() -> void:
	move_closer()

func _on_static_body_3d_mouse_exited() -> void:
	move_away()
