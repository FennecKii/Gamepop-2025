extends Node

enum SymbolID {BLANK, APPLE, BANANA, CHERRY, KIWI, WATERMELON, TOMATO, AVOCADO, PINEAPPLE, STRAWBERRY, MANGO}

var apple_texture = preload("res://icon.svg")

var bank: int
var goal: int
var slot_display: Array[int] = []
var slot_count: int = 5

func initialize(bank_amount: int, goal_amount: int, slot_size: int):
	bank = bank_amount
	goal = goal_amount
	slot_count = slot_size
	for i in range(slot_count):
		slot_display.append(SymbolID.BLANK)

func add_money(amount: int):
	bank += amount
