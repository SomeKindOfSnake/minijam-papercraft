extends Node3D

@onready var static_body_3d := $StaticBody3D as PhoneInputHandler

@export var camera: Camera3D

func _ready() -> void:
	static_body_3d.camera = camera
