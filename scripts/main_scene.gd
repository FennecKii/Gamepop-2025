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
@onready var streak_label = $StreakLabel

@onready var legend = $Legend
@onready var legend_anim = $Legend/AnimatedSprite2D

@onready var win_round_score_label = $WinRoundPanel/ScoreWinRoundLabel
@onready var win_round_money_label = $WinRoundPanel/MoneyWinRoundLabel
@onready var lose_panel_score_label = $LosePanel/ScoreLossLabel
@onready var lose_panel_money_label = $LosePanel/MoneyLossLabel
@onready var win_panel_score_label = $WinPanel/ScoreWinLabel
@onready var win_panel_money_label = $WinPanel/MoneyWinLabel


var spin_num: int = 0
var initial_target: int = 300
var initial_money: int = 100
var is_jackpot: bool = false
var streak_counter = 0

var legend_visible: bool = false
var target_position = Vector2(400,0)
var original_position = Vector2(-150,0)

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
	# var score_to_add = 0
	var multiplier = 0
	var win_this_spin = false
	var streak = 1
	var bonus = 0

	for num in counts.keys():
		var count = counts[num]

		if num == 1:  # Cherries (1) → Add 50 points per cherry & scales
			if count == 1:
				bonus += Global.bet_money * 0.1
			elif count == 2:
				bonus += Global.bet_money * 0.25
			elif count == 3:
				bonus += Global.bet_money * 0.5
				win_this_spin = true
			elif count == 4:
				bonus += Global.bet_money * 1
				win_this_spin = true
			elif count == 5:
				bonus += Global.bet_money * 2.5
				win_this_spin = true
				AudioPlayer.play_sfx(Global.jackpot)
			
			if Global.current_round == 2:
				bonus += Global.bet_money * 0.5
			elif Global.current_round == 3:
				bonus += Global.bet_money * 1
			elif Global.current_round == 4:
				bonus += Global.bet_money * 2
			elif Global.current_round == 5:
				bonus += Global.bet_money * 3
				
		elif num == 2:  # Bananas (2) → Apply multipliers based on count
			if count == 2:
				multiplier += 1.5
			elif count == 3:
				multiplier += 2.5
				win_this_spin = true
			elif count == 4:
				multiplier += 4
				win_this_spin = true
			elif count == 5:
				multiplier += 10
				win_this_spin = true
				AudioPlayer.play_sfx(Global.jackpot)
				
			if Global.current_round == 2:
				multiplier += 1
			elif Global.current_round == 3:
				multiplier += 2
			elif Global.current_round == 4:
				multiplier += 3
			elif Global.current_round == 5:
				multiplier += 4

		elif num == 3:  # 7s (3) → Apply multipliers based on count
			if count == 2:
				multiplier += 2
			elif count == 3:
				multiplier += 5
				win_this_spin = true
			elif count == 4:
				multiplier += 15
				win_this_spin = true
			elif count == 5:
				multiplier += 50
				win_this_spin = true
				AudioPlayer.play_sfx(Global.jackpot)
				is_jackpot = true
				
			if Global.current_round == 2:
				multiplier += 2
			elif Global.current_round == 3:
				multiplier += 3
			elif Global.current_round == 4:
				multiplier += 5
			elif Global.current_round == 5:
				multiplier += 7
	
	if win_this_spin == true:
		streak_counter += 1
	else:
		streak_counter = 0
	
	if multiplier == 0:
		multiplier = 1
	
	if streak_counter > 1:
		streak = streak_counter
		
	Global.player_score += ((Global.bet_money * multiplier) + bonus) * streak
	print(Global.bet_money)
	print("Multiplier: ", multiplier)
	print("Bonus: ", bonus)
	print("Streak Counter: ", streak_counter)
	
	update_score()
	update_labels()

func win_check():
	if Global.player_score >= Global.target_score and Global.current_round < Global.max_rounds: # Win condition
		award_reward()
		spin_num = 0
		Global.current_round += 1
		set_target_score(Global.current_round)
		win_round_score_label.text = "Score: " + str(Global.player_score)
		win_round_money_label.text = "Money: " + str(Global.player_money)
		Global.init_game_state(Global.current_round, Global.target_score, 0, Global.player_money)
		AudioPlayer.play_sfx(Global.round_win_sound)
		win_round_anim.play("win")
		await get_tree().create_timer(3).timeout
		win_round_panel.visible = true
	
	elif Global.player_score >= Global.target_score and Global.current_round == Global.max_rounds: # Final win condition
		award_reward()
		spin_num = 0
		win_panel_score_label.text = "Score: " + str(Global.player_score)
		win_panel_money_label.text = "Money: " + str(Global.player_money)
		Global.init_game_state(1, initial_target, 0, Global.player_money)
		AudioPlayer.stop()
		AudioPlayer.play_sfx(Global.game_win_sound)
		await get_tree().create_timer(3).timeout
		win_panel.visible = true
	
	elif spin_num == Global.max_spins and Global.player_score < Global.target_score and Global.current_round <= Global.max_rounds or Global.player_money < 10: # Lose condition
		spin_num = 0
		Global.current_round = 1
		lose_panel_score_label.text = "Score: " + str(Global.player_score)
		lose_panel_money_label.text = "Money: " + str(Global.player_money)
		Global.player_money = initial_money
		await get_tree().create_timer(1).timeout
		AudioPlayer.stop()
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
	streak_label.text = "Streak: " + str(streak_counter) + "x"
	rounds_label.text = "Round: " + str(Global.current_round)
	spins_label.text = "Spins\n" + str(Global.max_spins - spin_num)
	goal_label.text = "Goal: " + str(Global.target_score)

func _on_shop_pressed():
	update_score()
	AudioPlayer.play_sfx(Global.shop_click, -2)
	win_round_panel.visible = false
	shop.visible = true

func _on_play_again_pressed():
	AudioPlayer._play_music(Global.music_array.pick_random(), -5)
	AudioPlayer.play_sfx(Global.mystic_click,5)
	Global.max_spins = 5
	Global.init_game_state(1, initial_target, 0, initial_money)
	get_tree().change_scene_to_file("res://scenes/main_scene.tscn")

func _on_quit_pressed():
	AudioPlayer.play_sfx(Global.button_click, 5)
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
		AudioPlayer.stop()
		AudioPlayer.play_sfx(Global.game_lose_sound)
		lose_panel.visible = true

func set_target_score(round_num: int):
	if round_num == 1:
		Global.target_score = initial_target
	if round_num == 2:
		Global.target_score = 620
	if round_num == 3:
		Global.target_score = 2400
	if round_num == 4:
		Global.target_score = 6300
	if round_num == 5:
		Global.target_score = 10000

func calc_reward() -> int:
	var base_reward = 0
	var reward_multiplier: int = (Global.max_spins - spin_num) * 5
	if Global.current_round == 1:
		print(Global.player_score)
		print(Global.target_score)
		base_reward = Global.base_reward + (Global.player_score - Global.target_score)*0.25
	elif Global.current_round == 2:
		base_reward = Global.base_reward + (Global.player_score - Global.target_score)*0.5
	elif Global.current_round == 3:
		base_reward = Global.base_reward + (Global.player_score - Global.target_score)*1
	elif Global.current_round == 4:
		base_reward = Global.base_reward + (Global.player_score - Global.target_score)*1.25
	elif Global.current_round == 5:
		base_reward = Global.base_reward + (Global.player_score - Global.target_score)*1.50
		
	print(base_reward)
	print(reward_multiplier)
	return base_reward + reward_multiplier
	
func award_reward():
	var reward = calc_reward()
	Global.player_money += reward
	print(Global.player_money)

func _on_button_mouse_entered():
	AudioPlayer.play_sfx(Global.button_hover)

#legend
func _on_legend_button_pressed():
	var tween = create_tween()
	legend_visible = !legend_visible
	
	var new_position: Vector2
	if legend_visible:
		new_position = target_position
	else:
		new_position = original_position
	
	tween.tween_property(legend, "position", new_position, 1.0)
	legend_anim.play("default")
