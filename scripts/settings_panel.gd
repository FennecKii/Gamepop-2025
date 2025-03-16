extends TextureRect

func _process(delta):
	if Input.is_action_just_pressed("settings"):
		self.visible = !self.visible

func _on_master_volume_changed(value):
	if value == 0:
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)
	AudioServer.set_bus_volume_linear(0, value)

func _on_music_volume_changed(value):
	if value == 0:
		AudioServer.set_bus_mute(1, true)
	else:
		AudioServer.set_bus_mute(1, false)
	AudioServer.set_bus_volume_linear(1, value)

func _on_sfx_volume_changed(value):
	if value == 0:
		AudioServer.set_bus_mute(2, true)
	else:
		AudioServer.set_bus_mute(2, false)
	AudioServer.set_bus_volume_linear(2, value)

func _on_window_mode_item_selected(index):
	AudioPlayer.play_sfx(Global.button_click, 4)
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_close_pressed():
	AudioPlayer.play_sfx(Global.button_click, 5)
	self.visible = false

func _on_main_menu_pressed():
	AudioPlayer.play_sfx(Global.button_click, 5)
	AudioPlayer._play_music(Global.menu_music, 0.0)
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_button_entered():
	AudioPlayer.play_sfx(Global.button_hover)

func _on_volume_drag_started():
	AudioPlayer.play_sfx(Global.button_click, 4)
