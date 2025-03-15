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
	Global.slot_display = []
	for slot in slot_displays:
		var chosen_symbol = randi_range(1, 3) #len(Global.SymbolID) - 1)
		slot.texture = Global.texture_array[chosen_symbol]
		Global.slot_display.append(chosen_symbol)
	spin_pressed.emit()
