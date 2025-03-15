extends Node

# Enums for slot symbol textures
enum SymbolID {BLANK, APPLE, BANANA, CHERRY, KIWI, WATERMELON, TOMATO, AVOCADO, PINEAPPLE, STRAWBERRY, MANGO}

# Preload textures for slot symbols
@onready var blank_texture = preload("res://icon.svg")
@onready var apple_texture = preload("res://assets/7.png")
@onready var banana_texture = preload("res://assets/Banana.png")
@onready var cherry_texture = preload("res://assets/Cherry.png")

@onready var texture_array: Array = [
		blank_texture,
		apple_texture,
		banana_texture,
		cherry_texture
]

var bank: int
var goal: int

var slot_display: Array[int]

# Handles initialization of player's bank values, target money goal, slot machine size and display array initialization
func init_game_state(bank_amount: int, goal_amount: int):
	bank = bank_amount
	goal = goal_amount
