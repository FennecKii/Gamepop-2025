extends Control

@onready var bet_label = $PlayerBet
@onready var money_label = $PlayerMoney
@onready var money_prompt = $MoneyPrompt
@onready var bet_prompt = $BetPrompt
@onready var spin_prompt = $SpinPrompt
@onready var lever = $Button
@onready var lever_pull = $Button/AnimatedSprite2D
@onready var spin_audio = $SpinAudio

@onready var slot_displays = [
	$TextureRect/SlotDisplay/Slot1,
	$TextureRect/SlotDisplay/Slot2,
	$TextureRect/SlotDisplay/Slot3,
	$TextureRect/SlotDisplay/Slot4,
	$TextureRect/SlotDisplay/Slot5
]

@onready var slot_spin_displays = [
	$TextureRect/SlotSpinDisplay/Spin,
	$TextureRect/SlotSpinDisplay/Spin2,
	$TextureRect/SlotSpinDisplay/Spin3,
	$TextureRect/SlotSpinDisplay/Spin4,
	$TextureRect/SlotSpinDisplay/Spin5
]

var is_spinning: bool = false
var animation_playing: bool = false

signal spin_pressed

func _ready():
	money_update()

func money_update():
	money_label.text = "Money: " + str(Global.player_money)
	bet_label.text = "Bet: " + str(Global.bet_money)

func _on_minus_button_pressed():
	if Global.bet_money >= 10:
		Global.bet_money -= 10
		AudioPlayer.play_sfx(Global.subtract_money)
		money_update()

func _on_plus_button_pressed():
	if Global.player_money >= 10:
		Global.bet_money += 10
		AudioPlayer.play_sfx(Global.add_money)
		money_update()

func _on_button_pressed():
	if is_spinning: # Display text for when still spinning
		AudioPlayer.play_sfx(Global.negative_feedback)
		spin_prompt.visible = true
		await get_tree().create_timer(2).timeout
		spin_prompt.visible = false
	elif Global.bet_money == 0: # Display text for not enough bet
		AudioPlayer.play_sfx(Global.negative_feedback)
		bet_prompt.visible = true
		await get_tree().create_timer(2).timeout
		bet_prompt.visible = false
	elif !is_spinning and Global.player_money >= Global.bet_money: 
		is_spinning = true
		AudioPlayer.play_sfx(Global.lever, 1.0)
		# Plays lever animation
		lever_pull.play("pull")
		await lever_pull.animation_finished
		# Removes money from player when spining
		Global.player_money -= Global.bet_money
		money_update()
		
		for slot in len(slot_displays):
			slot_spin_displays[slot].set_frame(randi_range(0, 21))
			slot_spin_displays[slot].set_speed_scale(randf_range(0.75, 1.5))
			slot_spin_displays[slot].visible = true
			slot_displays[slot].visible = false
		# Resets symbol data array
		Global.slot_data = []
		# Loops through each texture rect
		for slot in len(slot_displays):
			# Picks random symbol from probability array
			var chosen_symbol = Global.player_prob_array.pick_random()
			spin_audio.play()
			await get_tree().create_timer(1.25).timeout
			if slot == 4:
				await get_tree().create_timer(0.75).timeout
			spin_audio.stop()
			# Disables visibility of spinning slots
			slot_spin_displays[slot].visible = false
			filter_audio(slot, 5)
			# Sets texture of texture rect
			slot_displays[slot].texture = Global.texture_array[chosen_symbol]
			slot_displays[slot].visible = true
			# Adds symbol to data array
			Global.slot_data.append(chosen_symbol)
		
		is_spinning = false
		# Emits signal connecting to main_scene.gd 
		spin_pressed.emit()
	else: # Display text for not enough money
		AudioPlayer.play_sfx(Global.negative_feedback)
		money_prompt.visible = true
		await get_tree().create_timer(2).timeout
		money_prompt.visible = false

func filter_audio(slot_position: int, volume: float = 0.0):
	if slot_position == 0:
		AudioPlayer.play_sfx(Global.coin7_click, volume)
	elif slot_position == 1:
		AudioPlayer.play_sfx(Global.coin2_click, volume)
	elif slot_position == 2:
		AudioPlayer.play_sfx(Global.coin1_click, volume)
	elif slot_position == 3:
		AudioPlayer.play_sfx(Global.coin3_click, volume)
	elif slot_position == 4:
		AudioPlayer.play_sfx(Global.coin5_click, volume)

func _on_shop_next_round_pressed(): # Signal
	Global.bet_money = 0
	money_update()

func _on_play_again_pressed(): # Signal
	Global.bet_money = 0

func _on_quit_pressed(): # Signal
	Global.bet_money = 0

func _on_button_mouse_entered():
	AudioPlayer.play_sfx(Global.button_hover)
