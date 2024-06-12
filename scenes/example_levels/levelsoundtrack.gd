extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	play(8.0)
	get_node("../FPSCharacter/CoinStash").coins_changed.connect(AudioDecrease)
	##get_node("../FPSCharacter/CoinStash_score").coins_changed.connect(AudioDecrease)
	$Timer.timeout.connect(IncreaseAudio)

func AudioDecrease(amount, delta):
	volume_db = -20
	$Timer.start()
	
func IncreaseAudio():
	volume_db = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
