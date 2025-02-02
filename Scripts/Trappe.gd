class_name Trappe extends Node3D

var openned = false

func open():
	if not openned:
		openned = true
		var tween = create_tween()
		tween.tween_property(self, "rotation_degrees", Vector3(-110, 0, 0), 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.play()
