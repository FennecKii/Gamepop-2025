extends Control

@onready var bet_label = $PlayerBet
@onready var money_label = $PlayerMoney
@onready var money_prompt = $MoneyPrompt
@onready var bet_prompt = $BetPrompt

@onready var slot_displays = [
	$TextureRect/SlotDisplay/Slot1,
	$TextureRect/SlotDisplay/Slot2,
	$TextureRect/SlotDisplay/Slot3,
	$TextureRect/SlotDisplay/Slot4,
	$TextureRect/SlotDisplay/Slot5
]

signal spin_pressed

func _ready():
	money_label.text = "Money: " + str(Global.player_money)

func _on_spin_button_pressed():
	if Global.bet_money == 0: # Not enough bet
		bet_prompt.visible = true
		await get_tree().create_timer(2).timeout
		bet_prompt.visible = false
	elif Global.player_money >= Global.bet_money:
		# Resets symbol data array
		Global.slot_data = []
		# Loops through each texture rect
		for slot in slot_displays:
			# Picks random symbol from probability array
			var chosen_symbol = Global.player_prob_array.pick_random()
			# Sets texture of texture rect
			slot.texture = Global.texture_array[chosen_symbol]
			# Adds symbol to data array
			Global.slot_data.append(chosen_symbol)
	
		# Removes money from player when spining
		Global.player_money -= Global.bet_money
		money_update()
		# Emits signal connecting to main_scene.gd 
		spin_pressed.emit()
	else: # Not enough money
		money_prompt.visible = true
		await get_tree().create_timer(2).timeout
		money_prompt.visible = false

func money_update():
	money_label.text = "Money: " + str(Global.player_money)
	bet_label.text = "Bet: " + str(Global.bet_money)

func _on_minus_button_pressed():
	if Global.bet_money >= 10:
		Global.bet_money -= 10
		money_update()

func _on_plus_button_pressed():
	if Global.player_money >= 10:
		Global.bet_money += 10
		money_update()
