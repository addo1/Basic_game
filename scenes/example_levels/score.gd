extends Label

var number = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	number = get_node("/root/Game/FPSLevel/FPSCharacter/CoinStash_score").score_in_stash
	text = "Score:" + str(number)

