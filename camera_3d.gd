extends Camera3D

var rotation_speed = 0.01
var radius = 30.0  # distance par rapport au centre
var angle = 80.0
var center = Vector3(-1, 7, 0)

func _process(delta):
	angle += rotation_speed * delta
	position.x = sin(angle) * radius
	position.z = cos(angle) * radius
	look_at(center)  # toujours regarder le centre de la maison


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
