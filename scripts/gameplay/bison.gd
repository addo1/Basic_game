extends Area3D

@export var required_soup = 3

func _ready():
	body_entered.connect(_on_bison_area_body_entered)

func _on_bison_area_body_entered(body):
	if body.has_node("CoinStash"):
		var coin_stash_node = body.get_node("CoinStash")
		if required_soup == coin_stash_node.coins_in_stash:
			print("something")
