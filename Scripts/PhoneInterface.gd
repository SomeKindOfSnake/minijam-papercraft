class_name PhoneInterface extends Control

@onready var phone_notification := $PhoneNotification as PhoneNotification

@export var dialogue: Dialogue

var current_step = 0
var base_y_position: float

var time = 1.0
var notif_visible = false
var finished = false

func _ready() -> void:
	base_y_position = phone_notification.position.y
	phone_notification.position.y = -300

func _process(delta: float) -> void:
	if not finished and not notif_visible:
		time -= delta
		if time <= 0:
			_load_line()
			current_step += 1

func _load_line() -> void:
	var options = dialogue.lines[current_step].split("]")[0].split(",")
	time = float(options[0])
	if time == -1:
		finished = true
	var line = dialogue.lines[current_step].split("]")[1]
	show_notification(line, float(options[1]))

func show_notification(text: String, stay_time: float) -> void:
	phone_notification.text = text
	phone_notification.position.y = -150
	notif_visible = true
	var tween = create_tween()
	tween.tween_property(phone_notification, "position", Vector2(phone_notification.position.x, base_y_position), .5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_interval(stay_time)
	tween.tween_property(phone_notification, "position", Vector2(phone_notification.position.x, -150), .5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(func(): notif_visible = false)
	tween.play()
