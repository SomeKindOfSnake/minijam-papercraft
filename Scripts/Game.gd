class_name Game extends Node3D

@onready var origami_maker := $OrigamiMaker as OrigamiMaker
@onready var phone := $Phone as Phone
@onready var trappe := $Trappe as Trappe
@onready var finished_papers := $FinishedPapers as Node3D

var current_pickable: Pickable

func _ready() -> void:
	randomize()

func request_picking(pickable: Pickable) -> bool:
	if current_pickable == null:
		current_pickable = pickable
		return true
	return false

func request_unpicking(pickable: Pickable) -> bool:
	if current_pickable == pickable:
		current_pickable = null
		return true
	return false

func on_button_released(button_name: String):
	if button_name == "CraneTutorialButton":
		origami_maker.start_crane()
		phone.start_tutorial(button_name)

func add_finished_paper(finished_paper: FinishedPaper):
	finished_papers.add_child(finished_paper)
	phone.stop_tutorial(2)

func on_next_step():
	phone.next_step()
