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

const max_rounds: int = 5
const max_spins: int = 5

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
@onready var lever = preload("res://audio/UI Positive Signal 002.wav")
@onready var round_win_sound = preload("res://audio/Jingle Win 002.wav")
@onready var game_win_sound = preload("res://audio/Jingle Win 001.wav")
@onready var game_lose_sound = preload("res://audio/Jingle Lose 001.wav")

# Handles initialization of player's bank values, target money goal, slot machine size and display array initialization
func init_game_state(round: int, target: int, score: int, money: int):
	player_score = score
	player_money = money
	target_score = target
	if round == 1:
		player_prob_array = default_prob_array.duplicate()
