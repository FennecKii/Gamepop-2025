extends Node

# Enums for slot symbol textures
enum SymbolID {BLANK, CHERRY, BANANA, SEVEN, KIWI, WATERMELON, TOMATO, AVOCADO, PINEAPPLE, STRAWBERRY, MANGO}

# Preload textures for slot symbols
@onready var blank_texture = preload("res://icon.svg")
@onready var banana_texture = preload("res://assets/Banana.png")
@onready var cherry_texture = preload("res://assets/Cherry.png")
@onready var seven_texture = preload("res://assets/7.png")

@onready var texture_array: Array = [
		blank_texture,
		banana_texture,
		cherry_texture,
		seven_texture
]

var bank: int = 0
var goal: int = 10000
var max_rounds: int = 5
var max_spins: int = 5
var slot_display: Array[int]
var default_prob_array: Array[int] = [1, 2, 3]
var player_prob_array: Array[int] = [1, 2, 3]

# Handles initialization of player's bank values, target money goal, slot machine size and display array initialization
func init_game_state(bank_amount: int, goal_amount: int, round: int):
	bank = bank_amount
	goal = goal_amount
	if round == 1:
		player_prob_array = default_prob_array.duplicate()
