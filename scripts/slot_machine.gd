extends Control

@onready var bet_money_label = $SpinButton/Label
@onready var money_label = $PlayerMoney

@onready var slot_displays = [
	$VBoxContainer/HBoxContainer/Slot1,
	$VBoxContainer/HBoxContainer/Slot2,
	$VBoxContainer/HBoxContainer/Slot3,
	$VBoxContainer/HBoxContainer/Slot4,
	$VBoxContainer/HBoxContainer/Slot5
]

signal spin_pressed

func _ready():
	money_label.text = "Money: " + str(Global.player_money)

func _on_spin_button_pressed():
	
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
	# Emits signal connects to main_scene.gd 
	spin_pressed.emit()

func money_update():
	money_label.text = "Money: " + str(Global.player_money)
	bet_money_label.text = "" + str(Global.bet_money)
	

func _on_minus_button_pressed():
	if Global.bet_money >= 10:
		Global.player_money += 10
		Global.bet_money -= 10
		money_update()
		

func _on_plus_button_pressed():
	if Global.player_money >= 10:
		Global.bet_money += 10
		Global.player_money -= 10
		money_update()
