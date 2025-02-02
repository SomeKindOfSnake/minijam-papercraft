class_name FinishedPaper extends Pickable

@export var paper_mesh: MeshInstance3D
@export var base_bode_name: String

func _ready() -> void:
	base_place = self if not game else game.get_node(base_bode_name)

func set_material(material: ShaderMaterial):
	paper_mesh.set_surface_override_material(0, material)
