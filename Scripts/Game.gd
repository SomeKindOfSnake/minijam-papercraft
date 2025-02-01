class_name Game extends Node3D

@onready var origami_maker := $OrigamiMaker as OrigamiMaker

func _ready() -> void:
	randomize()

func on_button_released(button_name: String):
	if button_name == "CraneTutorialButton":
		origami_maker.start_crane()
