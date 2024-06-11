extends Node

var score_in_stash = 0

signal score_changed(amount, delta)

func add_coins(amount):
	if amount < 0:
		return
	score_in_stash += amount
	emit_signal("score_changed", score_in_stash, amount)

func remove_coins(amount):
	if amount < 0:
		return
	if amount > score_in_stash:
		return
	score_in_stash -= amount
	emit_signal("score_changed", score_in_stash, -amount)
