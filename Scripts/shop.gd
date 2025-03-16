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
	if Global.player_money >= 10:
		AudioPlayer.play_sfx(Global.purchase_chime, -1)
		Global.player_money -= 10
		Global.max_spins += 1
		upgrade_extra_spin.text += "|"
		money_update()
	else:
		AudioPlayer.play_sfx(Global.negative_feedback)

func _on_change_prob_buy():
	if Global.player_money >= 20:
		AudioPlayer.play_sfx(Global.purchase_chime, -1)
		Global.player_money -= 20
		upgrade_increase_prob.text += "|"
		Global.player_prob_array.append([2,3].pick_random())
		money_update()
	else:
		AudioPlayer.play_sfx(Global.negative_feedback)

func _on_payout_increase():
	if Global.player_money >= 5:
		AudioPlayer.play_sfx(Global.purchase_chime, -1)
		Global.player_money -= 5
		upgrade_payout_increase.text += "|"
		money_update()
	else:
		AudioPlayer.play_sfx(Global.negative_feedback)

func _on_next_round():
	self.visible = false
	AudioPlayer.play_sfx(Global.next_round_click)
	next_round_pressed.emit()

func _on_shop_pressed():
	money_update()
	extra_spin_label.text = "Add Extra Spin (Cost: " + str(extra_spin_cost)+ ")"
	increase_prob_label.text = "Algorithm Override (Cost: " + str(algo_override_cost)+ ")"
	payout_increase_label.text = "Payout Increase (Cost: " + str(payout_increase_cost)+ ")"
