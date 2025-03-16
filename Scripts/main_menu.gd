extends Node2D
@onready var background = $Background2/AnimatedSprite2D

func _ready():
	background.play("default")

func _on_play_pressed():
	AudioPlayer.play_sfx(Global.mystic_click)
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")

func _on_quit_pressed():
	AudioPlayer.play_sfx(Global.button_click)
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
