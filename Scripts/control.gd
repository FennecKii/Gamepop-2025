extends Control

@onready var slot_displays = [
	$VBoxContainer/HBoxContainer/Slot1,
	$VBoxContainer/HBoxContainer/Slot2,
	$VBoxContainer/HBoxContainer/Slot3,
	$VBoxContainer/HBoxContainer/Slot4,
	$VBoxContainer/HBoxContainer/Slot5
]

@onready var spin_button = $VBoxContainer/SpinButton

var symbols = ["cherry", "banana", "7"]

func _ready():
	spin_button.pressed.connect(_on_spin_pressed)

func _on_spin_pressed():
	for slot in slot_displays:
		var chosen_symbol = symbols.pick_random()
		slot.texture = load("res://assets/%s.png" % chosen_symbol)
