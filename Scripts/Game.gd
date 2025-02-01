class_name Game extends Node3D

@onready var origami_maker := $OrigamiMaker as OrigamiMaker
@onready var phone := $phone as Phone

func _ready() -> void:
	randomize()

func on_button_released(button_name: String):
	if button_name == "CraneTutorialButton":
		origami_maker.start_crane()
		phone.start_tutorial(button_name)

func on_next_step():
	phone.next_step()
