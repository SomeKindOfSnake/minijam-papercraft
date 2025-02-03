class_name Game extends Node3D

signal all_placed

@onready var origami_maker := $OrigamiMaker as OrigamiMaker
@onready var phone := $Phone as Phone
@onready var trappe := $Trappe as Trappe
@onready var finished_papers := $FinishedPapers as Node3D

@onready var crystal := $Crystal as Crystal

@onready var crane_base := $CraneBase as PickableBase
@onready var dragon_base := $DragonBase as PickableBase
@onready var fox_base := $FoxBase as PickableBase
@onready var nine_tailed_fox_base := $NineTailedFoxBase as PickableBase
@onready var crystal_base := $CrystalBase as PickableBase

var current_pickable: Pickable

var magic_open = false
var is_all_placed = false

func _ready() -> void:
	randomize()

func _process(delta: float) -> void:
	if (
		crane_base.current_pickable and 
		fox_base.current_pickable and 
		crystal_base.current_pickable and
		not magic_open
	):
		magic_open = true
		crystal.on_magic_happens()
	
	if (
		crane_base.current_pickable and
		fox_base.current_pickable and
		dragon_base.current_pickable and
		nine_tailed_fox_base.current_pickable and
		crystal_base.current_pickable and
		not is_all_placed
	):
		is_all_placed = true
		crystal.on_magic_happens()

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
	elif button_name == "FoxTutorialButton":
		origami_maker.start_fox()
	phone.start_tutorial(button_name)

func add_finished_paper(finished_paper: FinishedPaper):
	finished_papers.add_child(finished_paper)
	origami_maker.reset()
	phone.stop_tutorial(2)

func switch_tutorial_to_special():
	phone.switch_to_special()

func on_next_step():
	phone.next_step()

func _on_crystal_magic_stops() -> void:
	if magic_open and not is_all_placed:
		trappe.open()
	elif magic_open and is_all_placed:
		all_placed.emit()
