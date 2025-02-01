class_name PhoneInterface extends Control

@onready var phone_notification := $PhoneNotification as PhoneNotification

var texts = "bonjour"
var value: bool = false

var base_y_position: float

func _ready() -> void:
	base_y_position = phone_notification.position.y
	phone_notification.visible = false

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_SPACE) and not value:
		texts += "\nbonjour"
		value = true
		show_notification(texts)

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_SPACE) and not value:
		texts += "\nbonjour"
		value = true
		show_notification(texts)

func show_notification(text: String):
	phone_notification.visible = true
	phone_notification.text = text
	phone_notification.position.y = -phone_notification.get_notification_size().y-60
	var tween = create_tween()
	tween.tween_property(phone_notification, "position", Vector2(phone_notification.position.x, base_y_position), .5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_interval(3)
	tween.tween_property(phone_notification, "position", Vector2(phone_notification.position.x, -phone_notification.get_notification_size().y-60), .5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(func(): value = false)
	tween.play()
