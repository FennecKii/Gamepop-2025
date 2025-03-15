extends Control

@onready var slot_displays = [
	$VBoxContainer/HBoxContainer/Slot1,
	$VBoxContainer/HBoxContainer/Slot2,
	$VBoxContainer/HBoxContainer/Slot3,
	$VBoxContainer/HBoxContainer/Slot4,
	$VBoxContainer/HBoxContainer/Slot5
]

signal spin_pressed

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
