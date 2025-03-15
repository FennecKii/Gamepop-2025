extends Control

@onready var score_label = $ScoreLabel
@onready var slot_machine = $SlotMachineUI

func _ready():
	update_score()
	
func update_score():
	score_label.text = "Score: " + str(Global.bank)

func check_results():
	var counts = {}  # Dictionary to store occurrences of each number

	# Count occurrences of each number in slot_display
	for num in Global.slot_display:
		counts[num] = counts.get(num, 0) + 1

	# Apply scoring rules
	var score_to_add = 0
	var multiplier = 1

	for num in counts.keys():
		var count = counts[num]

		if num == 1:  # Cherries (1) → Add 50 points per cherry
			score_to_add += count * 50

		elif num == 2:  # Bananas (2) → Apply multipliers based on count
			if count == 2:
				multiplier += 2
			elif count == 3:
				multiplier += 3
			elif count == 4:
				multiplier += 4

		elif num == 3:  # 7s (3) → Apply multipliers based on count
			if count == 3:
				multiplier += 10
			elif count == 4:
				multiplier += 20

		# If there are 5 of a kind of any number → Add global.goal to bank
		if count == 5:
			Global.bank += Global.goal
			update_score()
			return  # Skip other calculations if 5 of a kind is met

	# Apply multiplier (Bananas and 7s)
	Global.bank = Global.bank * multiplier

	# Add cherry points
	Global.bank += score_to_add

	update_score()


func _on_slot_machine_spin_pressed():
	check_results()
