extends Node

var coins_in_stash = 0

signal coins_changed(amount, delta)

func add_coins(amount):
	if amount < 0:
		return
	coins_in_stash += amount
	emit_signal("coins_changed", coins_in_stash, amount)
	get_node("/root/Game/FPSLevel/FPSCharacter/CoinStash_score").score_in_stash += amount
	emit_signal("score_changed", get_node("/root/Game/FPSLevel/FPSCharacter/CoinStash_score").score_in_stash, amount)
	var animation_player = get_node("/root/Game/FPSLevel/Plus_animation_1/show_plus")
	animation_player.play("show_plus")

func remove_coins(amount):
	if amount < 0:
		return
	if amount > coins_in_stash:
		return
	coins_in_stash -= amount
	emit_signal("coins_changed", coins_in_stash, -amount)
