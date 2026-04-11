extends Node2D

var glow_material : ShaderMaterial

var note_paths = {
	"C": preload("res://sounds/C.mp3"),
	"D": preload("res://sounds/D.mp3"),
	"E": preload("res://sounds/E.wav"),
	"F": preload("res://sounds/F.mp3"),
	"G": preload("res://sounds/G.mp3"),
	"A": preload("res://sounds/A.mp3"),
	"B": preload("res://sounds/B.mp3"),
	"As": preload("res://sounds/As.mp3"),
	"Cs": preload("res://sounds/Cs.mp3"),
	"Ds": preload("res://sounds/Ds.mp3"),
	"Fs": preload("res://sounds/Fs.mp3"),
	"Gs": preload("res://sounds/Gs.mp3"),
}

var is_azerty = true

var key_map_azerty = {
	KEY_Q: "C",
	KEY_S: "D",
	KEY_D: "E",
	KEY_F: "F",
	KEY_G: "G",
	KEY_H: "A",
	KEY_J: "B",
	KEY_Z: "Cs",
	KEY_E: "Ds",
	KEY_T: "Fs",
	KEY_Y: "Gs",
	KEY_U: "As",
}

var key_map_qwerty = {
	KEY_A: "C", # Q → A
	KEY_S: "D",
	KEY_D: "E",
	KEY_F: "F",
	KEY_G: "G",
	KEY_H: "A",
	KEY_J: "B",
	KEY_W: "Cs",  # Z → W
	KEY_E: "Ds",
	KEY_T: "Fs",
	KEY_Y: "Gs",
	KEY_U: "As",
}

var key_map = key_map_azerty

var note_ratios = {
	"C": 16.0 / 9.0,
	"D": 16.0 / 9.0,
	"E": 16.0 / 9.0,
	"F": 7.0 / 6.0,
	"G": 16.0 / 9.0,
	"A": 16.0 / 9.0,
	"B": 16.0 / 9.0,
	"Cs": 7.0 / 6.0,
	"Ds": 16.0 / 9.0,
	"Fs": 16.0 / 9.0,
	"Gs": 16.0 / 9.0,
	"As": 16.0 / 9.0,
}

@onready var house_node = $"SubViewportContainer/SubViewport/Node3D"  # adapt path
var original_materials = {}

func activate_house_glow(note):
	if house_node == null:
		return
	var area = house_node.find_child("Area3D_" + note, true, false)
	if area:
		var mesh = area.get_parent()
		# Save original before overriding
		original_materials[note] = mesh.get_active_material(0)
		mesh.set_surface_override_material(0, glow_material)

func deactivate_house_glow(note):
	if house_node == null:
		return
	var area = house_node.find_child("Area3D_" + note, true, false)
	if area:
		var mesh = area.get_parent()
		# Restore original instead of null
		mesh.set_surface_override_material(0, original_materials.get(note, null))


@onready var toggle_button = $"Keyboard Switch"  # adapte le chemin
@onready var help_button = $"Keyboard Switch2"
@onready var instruction_panel = $"Instruction Panel"  # adapt to your node name
@onready var instruction_image = $"Instruction Panel/InstructionImage"

var icon_azerty = preload("res://Icons/azerty.png")
var icon_qwerty = preload("res://Icons/qwerty.png")
var icon_az = preload("res://Icons/az.png")
var icon_qw = preload("res://Icons/qw.png")
var icon_qm = preload("res://Icons/qm.png")
var icon_questionmark = preload("res://Icons/questionmark.png")
var icon_instruction = preload("res://Icons/instruction_icon.png")

func toggle_keyboard():
	for note in active_players.keys():
		release_note(note)
	is_azerty = !is_azerty
	key_map = key_map_azerty if is_azerty else key_map_qwerty
	toggle_button.icon = icon_az if is_azerty else icon_qw

func _on_keyboard_switch_pressed():
	toggle_keyboard()

func _on_keyboard_switch_mouse_entered():
	if is_azerty:
		toggle_button.icon = icon_azerty
	else:
		toggle_button.icon = icon_qwerty

func _on_keyboard_switch_mouse_exited():
	if is_azerty:
		toggle_button.icon = icon_az
	else:
		toggle_button.icon = icon_qw

func _on_help_button_pressed():
	print("Help clicked!")  # we'll add the menu later
	instruction_panel.visible = !instruction_panel.visible  # toggle on/off

func _on_keyboard_switch_2_pressed() -> void:
	_on_help_button_pressed()

func _on_keyboard_switch_2_mouse_entered():
	help_button.icon = icon_questionmark

func _on_keyboard_switch_2_mouse_exited():
	help_button.icon = icon_qm

func _input(event):
	if event is InputEventKey and not event.echo:
		if event.keycode in key_map:
			var note = key_map[event.keycode]
			if event.pressed:
				play_note_held(note)
				key_buttons[note].add_theme_stylebox_override("normal", get_pressed_style())
			else:
				release_note(note)
				key_buttons[note].add_theme_stylebox_override("normal", get_normal_style())


func get_normal_style() -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = Color("ffc9c39b")  # base
	style.corner_radius_top_left = 4
	style.corner_radius_top_right = 4
	style.corner_radius_bottom_left = 4
	style.corner_radius_bottom_right = 4
	return style


func get_pressed_style() -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = Color(1, 1, 1)  # press
	style.corner_radius_top_left = 4
	style.corner_radius_top_right = 4
	style.corner_radius_bottom_left = 4
	style.corner_radius_bottom_right = 4
	return style


func get_hover_style() -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = Color("#ffffffaa")  # blanc semi-transparent au survol
	style.corner_radius_top_left = 4
	style.corner_radius_top_right = 4
	style.corner_radius_bottom_left = 4
	style.corner_radius_bottom_right = 4
	return style


var note_videos = {
	"C": preload("res://videos/C.ogv"),
	"D": preload("res://videos/D.ogv"),
	"E": preload("res://videos/E.ogv"),
	"F": preload("res://videos/F.ogv"),
	"G": preload("res://videos/G.ogv"),
	"A": preload("res://videos/A.ogv"),
	"B": preload("res://videos/B.ogv"),
	"Cs": preload("res://videos/Cs.ogv"),
	"Ds": preload("res://videos/Ds.ogv"),
	"Fs": preload("res://videos/Fs.ogv"),
	"Gs": preload("res://videos/Gs.ogv"),
	"As": preload("res://videos/As.ogv"),
}

var active_players = {}

@onready var video_players = {
	"C": $VideoPlayers/C,
	"D": $VideoPlayers/D,
	"E": $VideoPlayers/E,
	"F": $VideoPlayers/F,
	"G": $VideoPlayers/G,
	"A": $VideoPlayers/A,
	"B": $VideoPlayers/B,
	"Cs": $VideoPlayers/Cs,
	"Ds": $VideoPlayers/Ds,
	"Fs": $VideoPlayers/Fs,
	"Gs": $VideoPlayers/Gs,
	"As": $VideoPlayers/As,
}

@onready var key_buttons = {
	"C": $"Piano Ui/WhiteKeys/C",
	"D": $"Piano Ui/WhiteKeys/D",
	"E": $"Piano Ui/WhiteKeys/E",
	"F": $"Piano Ui/WhiteKeys/F",
	"G": $"Piano Ui/WhiteKeys/G",
	"A": $"Piano Ui/WhiteKeys/A",
	"B": $"Piano Ui/WhiteKeys/B",
	"Cs": $"Piano Ui/BlackKeys/Cs",
	"Ds": $"Piano Ui/BlackKeys/Ds",
	"Fs": $"Piano Ui/BlackKeys/Fs",
	"Gs": $"Piano Ui/BlackKeys/Gs",
	"As": $"Piano Ui/BlackKeys/As",
}


func play_video_for(note):
	if note in video_players:
		var vp = video_players[note]

		var rand_width = randf_range(200, 800)
		var rand_height = rand_width / note_ratios[note]
		vp.size = Vector2(rand_width, rand_height)

		var max_x = max(0, get_viewport_rect().size.x - rand_width)
		var max_y = max(0, get_viewport_rect().size.y - rand_height)
		vp.position = Vector2(randf_range(0, max_x), randf_range(0, max_y))
		
		vp.z_index = randi_range(100, 110)  # ← add this line

		video_players[note].stream = note_videos[note]
		video_players[note].loop = true
		video_players[note].visible = true
		video_players[note].play()


func stop_video_for(note):
	if note in video_players:
		video_players[note].stop()
		video_players[note].visible = false


func _ready():
	toggle_button.icon = icon_az  # icône au démarrage
	for vp in video_players.values():
		vp.visible = false
	var shader_mat = ShaderMaterial.new()
	shader_mat.shader = load("res://shader/invert.gdshader")
	toggle_button.material = shader_mat
	toggle_button.expand_icon = true
	glow_material = ShaderMaterial.new()
	glow_material.shader = load("res://shader/hover.gdshader")
	var empty_style = StyleBoxEmpty.new()
	toggle_button.add_theme_stylebox_override("normal", empty_style)
	toggle_button.add_theme_stylebox_override("hover", empty_style)
	toggle_button.add_theme_stylebox_override("pressed", empty_style)
	toggle_button.add_theme_stylebox_override("focus", empty_style)
	help_button.icon = icon_qm
	var empty_style_help = StyleBoxEmpty.new()
	help_button.add_theme_stylebox_override("normal", empty_style_help)
	help_button.add_theme_stylebox_override("hover", empty_style_help)
	help_button.add_theme_stylebox_override("pressed", empty_style_help)
	help_button.add_theme_stylebox_override("focus", empty_style_help)
	help_button.expand_icon = true
	var shader_mat_help = ShaderMaterial.new()
	shader_mat_help.shader = load("res://shader/invert.gdshader")
	instruction_panel.visible = false


func play_note_held(note):
	if note in active_players:
		return  # already playing, ignore repeat
	var p = AudioStreamPlayer.new()
	add_child(p)
	p.stream = note_paths[note]
	p.play()
	active_players[note] = p
	play_video_for(note)
	activate_house_glow(note)


func release_note(note):
	if note in active_players:
		var p = active_players[note]
		active_players.erase(note)
		var tween = create_tween()
		tween.tween_property(p, "volume_db", -80.0, 0.4)  # fade out over 0.4s
		tween.tween_callback(p.queue_free)
		stop_video_for(note)
		deactivate_house_glow(note)

func _on_c_button_down() -> void:
	play_note_held("C")


func _on_c_button_up() -> void:
	release_note("C")


func _on_d_button_down() -> void:
	play_note_held("D")


func _on_d_button_up() -> void:
	release_note("D")


func _on_e_button_down() -> void:
	play_note_held("E")


func _on_e_button_up() -> void:
	release_note("E")


func _on_f_button_down() -> void:
	play_note_held("F")


func _on_f_button_up() -> void:
	release_note("F")


func _on_g_button_down() -> void:
	play_note_held("G")


func _on_g_button_up() -> void:
	release_note("G")


func _on_a_button_down() -> void:
	play_note_held("A")


func _on_a_button_up() -> void:
	release_note("A")


func _on_b_button_down() -> void:
	play_note_held("B")


func _on_b_button_up() -> void:
	release_note("B")


func _on_cs_button_down() -> void:
	play_note_held("Cs")


func _on_cs_button_up() -> void:
	release_note("Cs")


func _on_ds_button_down() -> void:
	play_note_held("Ds")


func _on_ds_button_up() -> void:
	release_note("Ds")


func _on_fs_button_down() -> void:
	play_note_held("Fs")


func _on_fs_button_up() -> void:
	release_note("Fs")


func _on_gs_button_down() -> void:
	play_note_held("Gs")


func _on_gs_button_up() -> void:
	release_note("Gs")


func _on_as_button_down() -> void:
	play_note_held("As")


func _on_as_button_up() -> void:
	release_note("As")
