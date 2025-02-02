class_name Crystal extends Pickable

signal magic_stops

@onready var animation_player := $AnimationPlayer as AnimationPlayer

func on_magic_happens():
	input_event.disconnect(_on_input_event)
	animation_player.play("magic_happening")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	input_event.connect(_on_input_event)
	magic_stops.emit()
