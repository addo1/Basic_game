extends Area3D

@export var required_soup = 3
@export var was_transformed = false
@export var text_counter = 0

@onready var bison_text = $BisonText
@onready var bison_text2 = $BisonText2
@onready var bison_text3 = $BisonText3


func _ready():
	body_entered.connect(_on_bison_area_body_entered)

func _on_bison_area_body_entered(body):
	if body.has_node("CoinStash"):
		var coin_stash_node = body.get_node("CoinStash")
		_text_on_bison_enter(coin_stash_node)
		if required_soup == coin_stash_node.coins_in_stash:
			var ammo = get_node("/root/Game/FPSLevel/AmmoPickup")
			if !was_transformed:
				var ammo_position = ammo.transform
				ammo_position.origin.z -= 200
				ammo.transform = ammo_position
				print("ammo is here")
				was_transformed = true
		else:
			print("not enough soup")
			
func _text_on_bison_enter(coin_stash):
	print(text_counter)
	if text_counter > 0 and coin_stash.coins_in_stash < 3:
		bison_text2.visible = true
		await get_tree().create_timer(7.0).timeout
		bison_text2.visible = false
	if text_counter == 0:
		bison_text.visible = true
		await get_tree().create_timer(17.0).timeout
		bison_text.visible = false
		text_counter += 1
	if text_counter == 1 and coin_stash.coins_in_stash == 3:
		bison_text3.visible = true
		await get_tree().create_timer(12.0).timeout
		bison_text3.visible = false
		
		
	
