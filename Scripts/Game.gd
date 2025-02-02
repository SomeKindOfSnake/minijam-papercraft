class_name Game extends Node3D

@onready var origami_maker := $OrigamiMaker as OrigamiMaker
@onready var phone := $Phone as Phone
@onready var trappe := $Trappe as Trappe

func _ready() -> void:
	randomize()

func on_button_released(button_name: String):
	if button_name == "CraneTutorialButton":
		origami_maker.start_crane()
		phone.start_tutorial(button_name)
		trappe.open()

func on_next_step():
	phone.next_step()
