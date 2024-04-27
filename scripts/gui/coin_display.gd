extends Label

@export var player_coin_stash : Node

func _ready():
    # only connect the coins changed signal if the coin stash reference is valid
    if player_coin_stash != null:
        player_coin_stash.coins_changed.connect(_on_coins_changed)

func _on_coins_changed(amount, _delta):
    # simply change the text of the label to reflect the new amount of coins
    text = "Coins in stash: " + str(amount)