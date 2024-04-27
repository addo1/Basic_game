extends Node

var coins_in_stash = 0

signal coins_changed(amount, delta)

func add_coins(amount):
    if amount < 0:
        return
    coins_in_stash += amount
    emit_signal("coins_changed", coins_in_stash, amount)

func remove_coins(amount):
    if amount < 0:
        return
    if amount > coins_in_stash:
        return
    coins_in_stash -= amount
    emit_signal("coins_changed", coins_in_stash, -amount)