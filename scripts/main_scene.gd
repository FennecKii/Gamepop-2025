extends Control

@onready var score_label = $ScoreLabel
@onready var goal_label = $GoalLabel
@onready var win_panel = $WinPanel
@onready var lose_panel = $LosePanel
@onready var rounds_label = $Round
@onready var spins_label = $Spins
@onready var slot_machine = $SlotMachineUI

var round_num: int = 1
var spin_num: int = 0
var current_goal: int

func _ready():
	# Initialize game state
	Global.init_game_state(0, 10000, round_num)
	current_goal = 10000
	update_score()
	goal_label.text = "Goal: " + str(Global.goal)
	rounds_label.text = "Round: " + str(round_num)
	spins_label.text = "Spins Left: " + str(Global.max_spins - spin_num)

func _process(delta):
	pass

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
	win_check()

func win_check():
	if Global.bank >= Global.goal: # Win condition
		spin_num = 5
		round_num += 1
		win_panel.visible = true
	
	elif spin_num == Global.max_spins and  Global.bank < Global.goal: # Lose condition
		spin_num = 0
		round_num = 1
		lose_panel.visible = true

func _on_slot_machine_spin_pressed():
	spin_num += 1
	if spin_num <= 5:
		update_labels()
		check_results()

func update_labels():
	rounds_label.text = "Round: " + str(round_num)
	spins_label.text = "Spins Left: " + str(Global.max_spins - spin_num)
	goal_label.text = "Goal: " + str(current_goal)

func _on_shop_pressed():
	win_panel.visible = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_play_again_pressed():
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")

func _on_quit_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
