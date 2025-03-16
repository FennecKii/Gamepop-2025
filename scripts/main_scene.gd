extends Control

@onready var score_label = $ScoreLabel
@onready var goal_label = $GoalLabel
@onready var win_round_panel = $WinRoundPanel
@onready var win_round_anim = $WinRoundPanel/AnimatedSprite2D
@onready var win_panel = $WinPanel
@onready var lose_panel = $LosePanel
@onready var rounds_label = $Round
@onready var spins_label = $Spins
@onready var slot_machine = $SlotMachineUI
@onready var shop = $Shop

var spin_num: int = 0
var initial_target: int = 10000
var initial_money: int = 100
var is_jackpot: bool = false

func _ready():
	shop.visible = false
	win_round_panel.visible = false
	lose_panel.visible = false
	win_panel.visible = false
	# Initialize game state
	Global.init_game_state(1, initial_target, 0, initial_money)
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

		if num == 1:  # Cherries (1) → Add 50 points per cherry & scales
			if count <=2:
				score_to_add += count * 50
			elif count <= 4:
				score_to_add += count * 100
			elif count == 5:
				score_to_add += count * 1000
				AudioPlayer.play_sfx(Global.jackpot)
				
		elif num == 2:  # Bananas (2) → Apply multipliers based on count
			if count <=2:
				score_to_add += count * 200
			elif count <=4:
				score_to_add += count * 500
			elif count == 5:
				score_to_add += count * 5000
				AudioPlayer.play_sfx(Global.jackpot)

		elif num == 3:  # 7s (3) → Apply multipliers based on count
			if count <= 2:
				multiplier += 4
			elif count <=4:
				multiplier += 24
			elif count == 5:
				multiplier += 99
				AudioPlayer.play_sfx(Global.jackpot)
				is_jackpot = true

	# Add cherry points
	Global.player_score += score_to_add * multiplier
	
	update_score()
	update_labels()

func win_check():
	if Global.player_score >= Global.target_score and Global.current_round < Global.max_rounds: # Win condition
		spin_num = 0
		Global.current_round += 1
		set_target_score(Global.current_round)
		Global.init_game_state(Global.current_round, Global.target_score, 0, Global.player_money)
		AudioPlayer.play_sfx(Global.round_win_sound)
		win_round_anim.play("win")
		await get_tree().create_timer(3).timeout
		win_round_panel.visible = true
	
	elif Global.player_score >= Global.target_score and Global.current_round == Global.max_rounds: # Final win condition
		spin_num = 0
		Global.init_game_state(1, initial_target, 0, Global.player_money)
		AudioPlayer.play_sfx(Global.game_win_sound)
		await get_tree().create_timer(3).timeout
		win_panel.visible = true
	
	elif spin_num == Global.max_spins and Global.player_score < Global.target_score and Global.current_round <= Global.max_rounds or Global.player_money < 10: # Lose condition
		spin_num = 0
		Global.current_round = 1
		Global.player_money = initial_money
		await get_tree().create_timer(1).timeout
		AudioPlayer.play_sfx(Global.game_lose_sound)
		lose_panel.visible = true

func _on_slot_machine_spin_pressed():
	spin_num += 1
	if spin_num <= Global.max_spins:
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
	rounds_label.text = "Round: " + str(Global.current_round)
	spins_label.text = "Spins\n" + str(Global.max_spins - spin_num)
	goal_label.text = "Goal: " + str(Global.target_score)

func _on_shop_pressed():
	update_score()
	AudioPlayer.play_sfx(Global.coin4_click)
	win_round_panel.visible = false
	shop.visible = true

func _on_play_again_pressed():
	AudioPlayer.play_sfx(Global.mystic_click)
	Global.max_spins = 5
	Global.init_game_state(1, initial_target, 0, initial_money)
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")

func _on_quit_pressed():
	AudioPlayer.play_sfx(Global.button_click)
	AudioPlayer._play_music(Global.menu_music, 0.0)
	Global.max_spins = 5
	Global.init_game_state(1, initial_target, 0, initial_money)
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_shop_next_round_pressed():
	update_score()
	update_labels()
	if Global.player_money < 10:
		spin_num = 0
		await get_tree().create_timer(3).timeout
		AudioPlayer.play_sfx(Global.game_lose_sound)
		lose_panel.visible = true

func set_target_score(round: int):
	if round == 1:
		Global.target_score = initial_target
	if round == 2:
		Global.target_score = 50000
	if round == 3:
		Global.target_score = 100000
	if round == 4:
		Global.target_score = 250000
	if round == 5:
		Global.target_score = 1000000
