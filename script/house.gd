extends Node3D

var wireframe_shader = preload("res://shader/wireframe.gdshader")

func _ready():
	apply_wireframe(self)

func apply_wireframe(node):
	if node is MeshInstance3D:
		for i in node.get_surface_override_material_count():
			var mat = ShaderMaterial.new()
			mat.shader = wireframe_shader
			node.set_surface_override_material(i, mat)
	for child in node.get_children():
		apply_wireframe(child)
