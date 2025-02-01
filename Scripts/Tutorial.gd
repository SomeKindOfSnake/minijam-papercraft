class_name Tutorial extends Control

@onready var tutorial_menu := $TutorialMenu as TutorialMenu
@onready var tutorial_steps := $TutorialSteps as TutorialSteps

@export var phone_inputs_handler: PhoneInputHandler
@export var tutorials: Array[TutorialStepsResource]

func _ready() -> void:
	phone_inputs_handler.mouse_moved_on_phone.connect(tutorial_menu.on_mouse_move)

func start_tutorial(tutorial: String):
	tutorial_menu.visible = false
	tutorial_steps.visible = true
	match tutorial:
		"CraneTutorialButton":
			tutorial_steps.reset(tutorials[0])

func next_step():
	tutorial_steps.next_step()
