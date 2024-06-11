extends Area3D

# the value of the collectable coin
@export var value = 1

signal collected

func _ready():
	# connect the body_entered signal to the _on_coin_body_entered function when starting play
	body_entered.connect(_on_coin_body_entered)

func _on_coin_body_entered(body):
	# check if the body entered has the CoinStash node
	# if it doesn't, do nothing
	if body.has_node("CoinStash_score"):
		var coin_stash = body.get_node("CoinStash_score")
		coin_stash.add_coins(value)
		# disable the coin trigger
		set_deferred("monitorable", false)
		set_deferred("monitoring", false)
		# hide the coin
		visible = false
		print(coin_stash.score_in_stash)
		# play the coin added sound and monitor when the sound is finished
		$CoinSound.play()
		$CoinSound.finished.connect(_on_coin_sound_finished)
		collected.emit()

func _on_coin_sound_finished():
	# remove the coin from the scene once the sound is finished
	queue_free()
