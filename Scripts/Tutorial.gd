class_name Tutorial extends Control

@onready var tutorial_menu := $TutorialMenu as TutorialMenu
@onready var tutorial_steps := $TutorialSteps as TutorialSteps

@export var phone_inputs_handler: PhoneInputHandler
@export var tutorials: Array[TutorialStepsResource]
@export var special_tutorial: Array[TutorialStepsResource]

var current_tutorial: String
var special = false

func _ready() -> void:
	phone_inputs_handler.mouse_moved_on_phone.connect(tutorial_menu.on_mouse_move)

func switch_to_special():
	if not special:
		special = true
		match current_tutorial:
			"CraneTutorialButton":
				var previous_step = tutorial_steps.current_step
				tutorial_steps.reset(special_tutorial[0])
				tutorial_steps.select_step(previous_step)
			"FoxTutorialButton":
				var previous_step = tutorial_steps.current_step
				tutorial_steps.reset(special_tutorial[1])
				tutorial_steps.select_step(previous_step)

func start_tutorial(tutorial: String):
	special = false
	current_tutorial = tutorial
	tutorial_menu.visible = false
	tutorial_steps.visible = true
	match tutorial:
		"CraneTutorialButton":
			tutorial_steps.reset(tutorials[0])
		"FoxTutorialButton":
			tutorial_steps.reset(tutorials[1])

func stop_tutorial():
	tutorial_menu.visible = true
	tutorial_steps.visible = false

func next_step():
	tutorial_steps.next_step()
