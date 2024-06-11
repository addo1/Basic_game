extends Area3D

@export var required_soup = 3
@export var was_transformed = false
@onready var bison_text = $BisonText
@export var text_counter = 0


func _ready():
	body_entered.connect(_on_bison_area_body_entered)

func _on_bison_area_body_entered(body):
	if body.has_node("CoinStash"):
		_text_on_bison_enter()
		var coin_stash_node = body.get_node("CoinStash")
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
			
func _text_on_bison_enter():
	match text_counter:
		1:
			bison_text.visible = true
			await get_tree().create_timer(10.0).timeout
			bison_text.visible = false
	
