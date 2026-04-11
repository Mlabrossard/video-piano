extends Camera3D

var radius = 30.0
var angle = 80.0
var center = Vector3(-1, 7, 0)

var auto_rotation_speed = 0.05
var is_dragging = false
var last_mouse_pos = Vector2.ZERO
var drag_sensitivity = 0.005

func _process(delta):
	if not is_dragging:
		# rotation automatique quand pas en train de drag
		angle += auto_rotation_speed * delta
		position.x = sin(angle) * radius
		position.z = cos(angle) * radius
		look_at(center)
