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
@onready var shop = $Shop

var extra_spin_cost = 10
var algo_override_cost = 20
var payout_increase_cost = 5

func _ready():
	player_money.text = "Current Money: " + str(Global.player_money)
	extra_spin_label.text = "Add Extra Spin (Cost: " + str(extra_spin_cost)+ ")"
	increase_prob_label.text = "Algorithm Override (Cost: " + str(algo_override_cost)+ ")"
	payout_increase_label.text = "Payout Increase (Cost: " + str(payout_increase_cost)+ ")"
	extra_spin_buy.pressed.connect(_on_extra_spin_buy)
	change_prob_buy.pressed.connect(_on_change_prob_buy)
	payout_increase_buy.pressed.connect(_on_payout_increase)
	next_round_button.pressed.connect(_on_next_round)

func money_update():
	player_money.text = "Current Money: " + str(Global.player_money)

func _on_extra_spin_buy():
	if Global.player_money >= 10:
		Global.player_money -= 10
		Global.max_spins += 1
		money_update()

func _on_change_prob_buy():
	if Global.player_money >= 20:
		Global.player_money -= 20
		Global.player_prob_array.append(Global.default_prob_array.pick_random())
		money_update()

func _on_payout_increase():
	if Global.player_money >= 5:
		Global.player_money -= 5
		money_update()

func _on_next_round():
	shop.visible = false
