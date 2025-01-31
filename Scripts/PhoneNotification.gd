class_name PhoneNotification extends Control

@onready var rich_text_label := $MarginContainer/VBoxContainer/RichTextLabel as RichTextLabel
@onready var margin_container := $MarginContainer as MarginContainer

@export var text: String:
	set(value):
		text = value
		if rich_text_label != null:
			rich_text_label.text = "[center]"+text+"[/center]"

func get_notification_size() -> Vector2:
	return margin_container.get_global_rect().size
