extends Node

# Enums for slot symbol textures
enum IconID {BLANK, CHERRY, BANANA, SEVEN, KIWI, WATERMELON, TOMATO, AVOCADO, PINEAPPLE, STRAWBERRY, MANGO}

# Preload textures for slot symbols
@onready var blank_texture = preload("res://icon.svg")
@onready var banana_texture = preload("res://assets/Banana.png")
@onready var cherry_texture = preload("res://assets/Cherry.png")
@onready var seven_texture = preload("res://assets/7.png")

@onready var texture_array: Array = [
		blank_texture,
		cherry_texture,
		banana_texture,
		seven_texture
]

var max_rounds: int = 5
var max_spins: int = 5

var bet_money: int
var player_score: int
var player_money = 100
var target_score: int
var slot_data: Array[int]
var default_prob_array: Array[int] = [1, 1, 1, 2, 2, 3]
var player_prob_array: Array[int]

# Audio preloads
@onready var button_click = preload("res://audio/Funk Click A.wav")
@onready var button_hover = preload("res://audio/Funk Click B.wav")
@onready var mystic_click = preload("res://audio/Mystic Click A.wav")
@onready var coin1_click = preload("res://audio/Coin 001.wav")
@onready var coin2_click = preload("res://audio/Coin 002.wav")
@onready var coin3_click = preload("res://audio/Coin 003.wav")
@onready var coin4_click = preload("res://audio/Coin 004.wav")
@onready var coin5_click = preload("res://audio/Coin 005.wav")
@onready var coin6_click = preload("res://audio/Coin 006.wav")
@onready var coin7_click = preload("res://audio/Coin 007.wav")
@onready var jackpot = preload("res://audio/777.wav")
@onready var add_money = preload("res://audio/Bad Button 002.wav")
@onready var subtract_money = preload("res://audio/Bad Button 001.wav")
@onready var lever = preload("res://audio/lever-action-cocking-2-39680.mp3")
@onready var round_win_sound = preload("res://audio/Jingle Win 002.wav")
@onready var game_win_sound = preload("res://audio/Jingle Win 001.wav")
@onready var game_lose_sound = preload("res://audio/Jingle Lose 001.wav")
@onready var negative_feedback = preload("res://audio/Gain B 16-Bit.wav")
@onready var spin_sound = preload("res://audio/mixkit-slot-machine-wheel-1932.wav")
@onready var menu_music = preload("res://audio/background music/Lo-Fi Bond Intensity 2.wav")
@onready var background_music1 = preload("res://audio/background music/Electronic Vol6 Lazer Invaders Intensity 1.wav")
@onready var background_music2 = preload("res://audio/background music/Electronic Vol5 Golden Gates Intensity 1.wav")
@onready var background_music3 = preload("res://audio/background music/Electronic Vol6 Bulletin Intensity 1.wav")
@onready var background_music4 = preload("res://audio/background music/Electronic Vol6 Color Swing Intensity 1.wav")

@onready var music_array: Array = [
	background_music1,
	background_music2,
	background_music3,
	background_music4
]

# Handles initialization of player's bank values, target money goal, slot machine size and display array initialization
func init_game_state(round: int, target: int, score: int, money: int):
	player_score = score
	player_money = money
	target_score = target
	if round == 1:
		player_prob_array = default_prob_array.duplicate()
