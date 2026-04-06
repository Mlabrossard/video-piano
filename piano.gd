extends Node2D

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

var key_map = {
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
	style.bg_color = Color("59c9c39b")  # base
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

		var rand_width = randf_range(200, 600)
		var rand_height = rand_width / note_ratios[note]
		vp.size = Vector2(rand_width, rand_height)

		var max_x = max(0, get_viewport().size.x - rand_width)
		var max_y = max(0, get_viewport().size.y - rand_height)
		vp.position = Vector2(randf_range(0, max_x), randf_range(0, max_y))

		video_players[note].stream = note_videos[note]
		video_players[note].loop = true
		video_players[note].visible = true
		video_players[note].play()


func stop_video_for(note):
	if note in video_players:
		video_players[note].stop()
		video_players[note].visible = false


func _ready():
	for vp in video_players.values():
		vp.visible = false


func play_note_held(note):
	if note in active_players:
		return  # already playing, ignore repeat
	var p = AudioStreamPlayer.new()
	add_child(p)
	p.stream = note_paths[note]
	p.play()
	active_players[note] = p
	play_video_for(note)


func release_note(note):
	if note in active_players:
		var p = active_players[note]
		active_players.erase(note)
		var tween = create_tween()
		tween.tween_property(p, "volume_db", -80.0, 0.4)  # fade out over 0.4s
		tween.tween_callback(p.queue_free)
		stop_video_for(note)


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
