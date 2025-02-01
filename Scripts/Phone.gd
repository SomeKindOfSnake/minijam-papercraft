class_name Phone extends Node3D

@onready var static_body_3d := $StaticBody3D as PhoneInputHandler
@onready var tutorial := $SubViewport/Tutorial as Tutorial

func start_tutorial(button_name: String):
	tutorial.start_tutorial(button_name)

func next_step():
	tutorial.next_step()
