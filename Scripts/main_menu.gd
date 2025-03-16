extends Node2D
@onready var background = $Background2/AnimatedSprite2D

func _ready():
	background.play("default")
	AudioPlayer._play_music(Global.menu_music, 0.0)
	AudioServer.set_bus_volume_db(0, -1)
	AudioServer.set_bus_volume_db(1, -1)
	AudioServer.set_bus_volume_db(2, -1)

func _on_play_pressed():
	AudioPlayer.play_sfx(Global.mystic_click, 5)
	AudioPlayer._play_music(Global.music_array.pick_random(), -6)
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")

func _on_quit_pressed():
	AudioPlayer.play_sfx(Global.button_click, 5)
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()

func _on_button_mouse_entered():
	AudioPlayer.play_sfx(Global.button_hover)
