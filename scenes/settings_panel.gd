extends ColorRect

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
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
