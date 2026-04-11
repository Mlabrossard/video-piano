extends Area3D

@export var note_name: String = "B"
var hover_material : ShaderMaterial
var original_material

@onready var mesh = get_parent()  # le MeshInstance3D parent

func _ready():
	input_ray_pickable = true
	
		# Crée le matériau de hover
	hover_material = ShaderMaterial.new()
	hover_material.shader = load("res://shader/hover.gdshader")
	
	# Sauvegarde le matériau original
	original_material = mesh.get_active_material(0)
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	mesh.set_surface_override_material(0, hover_material)

func _on_mouse_exited():
	var piano = get_tree().get_root().get_node("Piano")
	# Only restore if note is not currently playing
	if not note_name in piano.active_players:
		mesh.set_surface_override_material(0, original_material)

func _input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				get_tree().get_root().get_node("Piano").play_note_held((note_name))
			else:
				get_tree().get_root().get_node("Piano").release_note((note_name))
