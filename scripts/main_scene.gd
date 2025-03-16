extends Control

@onready var score_label = $ScoreLabel
@onready var goal_label = $GoalLabel
@onready var win_round_panel = $WinRoundPanel
@onready var win_panel = $WinPanel
@onready var lose_panel = $LosePanel
@onready var rounds_label = $Round
@onready var spins_label = $Spins
@onready var slot_machine = $SlotMachineUI

var round_num: int = 1
var spin_num: int = 0
var initial_target: int = 10000
var initial_money: int
var is_jackpot: bool = false

func _ready():
	# Initialize game state
	Global.init_game_state(round_num, initial_target, 0, Global.player_money)
	update_score()
	update_labels()

func check_results():
	var counts = {}  # Dictionary to store occurrences of each number

	# Count occurrences of each number in slot_display
	for num in Global.slot_data:
		counts[num] = counts.get(num, 0) + 1

	# Apply scoring rules
	var score_to_add = Global.bet_money
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
			Global.player_score += Global.target_score
			AudioPlayer.play_sfx(Global.jackpot)
			update_score()
			is_jackpot = true
			return  # Skip other calculations if 5 of a kind is met

	# Add cherry points
	Global.player_score += score_to_add
	# Apply multiplier (Bananas and 7s)
	Global.player_score *= multiplier
	
	update_score()
	update_labels()

func win_check():
	if Global.player_score >= Global.target_score and round_num < Global.max_rounds: # Win condition
		spin_num = 0
		round_num += 1
		Global.init_game_state(round_num, Global.target_score*2, 0, Global.player_money)
		AudioPlayer.play_sfx(Global.round_win_sound)
		win_round_panel.visible = true
	
	elif Global.player_score >= Global.target_score and round_num == Global.max_rounds: # Final win condition
		spin_num = 0
		round_num = 1
		Global.init_game_state(round_num, initial_target, 0, Global.player_money)
		AudioPlayer.play_sfx(Global.game_win_sound)
		win_panel.visible = true
	
	elif spin_num == Global.max_spins and Global.player_score < Global.target_score and round_num <= Global.max_rounds or Global.player_money == 0: # Lose condition
		spin_num = 0
		round_num = 1
		AudioPlayer.play_sfx(Global.game_lose_sound)
		lose_panel.visible = true

func _on_slot_machine_spin_pressed():
	spin_num += 1
	if spin_num <= 5:
		update_labels()
		check_results()
		if is_jackpot:
			await get_tree().create_timer(3).timeout
			win_check()
		else:
			win_check()
		is_jackpot = false

func update_score():
	score_label.text = str(Global.player_score)

func update_labels():
	rounds_label.text = "Round: " + str(round_num)
	spins_label.text = "Spins\n" + str(Global.max_spins - spin_num)
	goal_label.text = "Goal: " + str(Global.target_score)

func _on_shop_pressed():
	update_score()
	update_labels()
	AudioPlayer.play_sfx(Global.coin4_click)
	win_round_panel.visible = false

func _on_play_again_pressed():
	AudioPlayer.play_sfx(Global.mystic_click)
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")

func _on_quit_pressed():
	AudioPlayer.play_sfx(Global.button_click)
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
