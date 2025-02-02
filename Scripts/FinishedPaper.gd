class_name FinishedPaper extends Pickable

@export var paper_mesh: MeshInstance3D
@export var base_node_name: String
@export var respawn_node_name: String
@export var animation_player: AnimationPlayer

@export var idle_animation: String
@export var walking_animation: String
@export var cheering_animation: String

var alive = true

var current_direction = Vector3.FORWARD
var walking = false
var pausing = false

var time_before_next = 3.0
var time_before_cheering = 10.0

var max_velocity = 0.5

func _ready() -> void:
	super._ready()
	
	max_velocity = randf_range(0.2, 0.8)
	
	pickable_base = self if not game else game.get_node(base_node_name)
	respawn_base = self if not game else game.get_node(respawn_node_name)
	
	if game.is_all_placed:
		turn_alive()
	
	game.all_placed.connect(turn_alive)
	animation_player.animation_finished.connect(on_animation_done)

func set_material(material: ShaderMaterial):
	paper_mesh.set_surface_override_material(0, material)

func mul_scale(offset: float):
	base_node.scale *= offset

func turn_alive():
	alive = true
	time_before_next = randf_range(1.0, 5.0)
	var random_angle = randf_range(0.0, PI*2)
	var current_angle = rotation.y
	current_direction = -Vector3.FORWARD.rotated(Vector3.UP, random_angle)
	var angle_random_difference = (random_angle-current_angle)-2*PI*floor((random_angle-current_angle)/(2*PI))
	angle_random_difference = (angle_random_difference - 2*PI) if angle_random_difference > PI else angle_random_difference
	var tween = create_tween()
	tween.tween_property(self, "rotation", Vector3(0, current_angle+angle_random_difference, 0), 1.5*abs(angle_random_difference/PI)).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.play()
	tween = create_tween()
	tween.tween_interval(randf_range(0.0, 1.0))
	tween.tween_callback(func(): animation_player.play(cheering_animation))
	tween.play()

func on_animation_done(animation_name: StringName):
	if animation_name == cheering_animation:
		animation_player.play(walking_animation)
		walking = true

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if alive and not is_carried and walking:
		time_before_cheering -= delta
		if time_before_cheering <= 0.0:
			walking = false
			animation_player.stop()
			animation_player.play(cheering_animation)
			time_before_cheering = randf_range(10.0, 20.0)
	
	if alive and not is_carried and pausing and walking:
		time_before_next -= delta
		if time_before_next <= 0.0:
			pausing = false
			animation_player.stop()
			animation_player.play(walking_animation)
			time_before_next = randf_range(1.0, 5.0)
	
	if alive and not is_carried and walking and not pausing:
		if linear_velocity.length() < max_velocity:
			apply_central_force(current_direction*delta*1500)
		
		time_before_next -= delta
		if time_before_next <= 0.0:
			animation_player.stop()
			animation_player.play(idle_animation)
			pausing = true
			time_before_next = randf_range(1.0, 5.0)
			var random_angle = randf_range(0.0, PI*2)
			var current_angle = rotation.y
			current_direction = -Vector3.FORWARD.rotated(Vector3.UP, random_angle)
			var angle_random_difference = (random_angle-current_angle)-2*PI*floor((random_angle-current_angle)/(2*PI))
			angle_random_difference = (angle_random_difference - 2*PI) if angle_random_difference > PI else angle_random_difference
			var tween = create_tween()
			tween.tween_property(self, "rotation", Vector3(0, current_angle+angle_random_difference, 0), 1.5*abs(angle_random_difference/PI)).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			tween.play()
