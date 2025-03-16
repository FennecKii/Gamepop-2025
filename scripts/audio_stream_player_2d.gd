extends AudioStreamPlayer2D

func play_sfx(stream: AudioStream, volume: float = 0.0):
	var sfx_player = AudioStreamPlayer2D.new()
	sfx_player.stream = stream
	sfx_player.volume_db = volume
	sfx_player.bus = "SFX"
	add_child(sfx_player)
	sfx_player.play()
	await sfx_player.finished
	sfx_player.queue_free()
