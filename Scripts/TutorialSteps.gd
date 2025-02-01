class_name TutorialSteps extends Control

@onready var label := $Label as Label
@onready var texture_rect := $VBoxContainer/TextureRect as TextureRect

@export var tutorial_steps_resource: TutorialStepsResource

var current_step = 1

func reset(steps: TutorialStepsResource):
	current_step = 1
	tutorial_steps_resource = steps
	label.text = "Step "+str(current_step)
	texture_rect.texture = tutorial_steps_resource.steps[current_step-1]

func next_step():
	current_step += 1
	label.text = "Step "+str(current_step)
	texture_rect.texture = tutorial_steps_resource.steps[current_step-1]
