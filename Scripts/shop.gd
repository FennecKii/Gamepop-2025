extends Control

@onready var extra_spin_buy = $ExtraSpinBuyButton
@onready var change_prob_buy = $ChangeProbBuyButton
@onready var payout_increase_buy = $PayoutIncreaseBuyButton
@onready var next_round_button = $NextRoundButton
@onready var extra_spin_label = $ExtraSpinLabel
@onready var increase_prob_label = $IncreaseProbLabel
@onready var payout_increase_label = $PayoutIncreaseLabel
@onready var next_round = $NextRoundButton
@onready var player_money = $CurrentMoneyLabel
@onready var upgrade_extra_spin = $UpgradeExtraSpinLabel
@onready var upgrade_increase_prob = $UpgradeIncreaseProbLabel
@onready var upgrade_payout_increase = $UpgradePayoutIncreaseLabel

signal next_round_pressed

var extra_spin_cost = 10
var algo_override_cost = 20
var payout_increase_cost = 5

func money_update():
	player_money.text = "Current Money: " + str(Global.player_money)

func _on_extra_spin_buy():
	if Global.player_money >= extra_spin_cost:
		AudioPlayer.play_sfx(Global.purchase_chime, -1)
		Global.player_money -= extra_spin_cost
		Global.max_spins += 1
		upgrade_extra_spin.text += "|"
		money_update()
	else:
		AudioPlayer.play_sfx(Global.negative_feedback)

func _on_change_prob_buy():
	if Global.player_money >= algo_override_cost:
		AudioPlayer.play_sfx(Global.purchase_chime, -1)
		Global.player_money -= algo_override_cost
		upgrade_increase_prob.text += "|"
		Global.player_prob_array.append([2,3].pick_random())
		money_update()
	else:
		AudioPlayer.play_sfx(Global.negative_feedback)

func _on_payout_increase():
	if Global.player_money >= payout_increase_cost:
		AudioPlayer.play_sfx(Global.purchase_chime, -1)
		Global.player_money -= payout_increase_cost
		upgrade_payout_increase.text += "|"
		Global.base_reward += 2
		money_update()
	else:
		AudioPlayer.play_sfx(Global.negative_feedback)

func _on_next_round():
	self.visible = false
	AudioPlayer.play_sfx(Global.next_round_click)
	next_round_pressed.emit()

func _on_shop_pressed():
	money_update()
	set_shop_prices()
	extra_spin_label.text = "Add Extra Spin (Cost: " + str(extra_spin_cost)+ ")"
	increase_prob_label.text = "Algorithm Override (Cost: " + str(algo_override_cost)+ ")"
	payout_increase_label.text = "Payout Increase (Cost: " + str(payout_increase_cost)+ ")"

func set_shop_prices():
	if Global.current_round - 1 == 1:
		extra_spin_cost = 10
		algo_override_cost = 20
		payout_increase_cost = 5
	if Global.current_round - 1 == 2:
		extra_spin_cost = 15
		algo_override_cost = 25
		payout_increase_cost = 10
	if Global.current_round - 1 == 3:
		extra_spin_cost = 20
		algo_override_cost = 30
		payout_increase_cost = 15
	if Global.current_round - 1 == 4:
		extra_spin_cost = 25
		algo_override_cost = 35
		payout_increase_cost = 20
	if Global.current_round - 1 == 5:
		extra_spin_cost = 30
		algo_override_cost = 40
		payout_increase_cost = 25
