extends AudioStreamPlayer2D

func _play_music(music: AudioStream, volume: float = 0.0):
	if stream == music:
		return
	stream = music
	volume_db = volume
	play()

func play_sfx(sfx_stream: AudioStream, volume: float = 0.0):
	var sfx_player = AudioStreamPlayer2D.new()
	sfx_player.stream = sfx_stream
	sfx_player.volume_db = volume
	sfx_player.bus = "SFX"
	add_child(sfx_player)
	sfx_player.play()
	await sfx_player.finished
	sfx_player.queue_free()
