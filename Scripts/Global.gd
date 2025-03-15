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

var player_score: int
var player_money: int
var target_score: int
var slot_data: Array[int]
var default_prob_array: Array[int] = [1, 1, 1, 1, 2, 2, 3]
var player_prob_array: Array[int]

# Handles initialization of player's bank values, target money goal, slot machine size and display array initialization
func init_game_state(round: int, target: int, score: int, money: int):
	player_score = score
	player_money = money
	target_score = target
	if round == 1:
		player_prob_array = default_prob_array.duplicate()
