extends Area3D

# how much ammo will this pickup grant
@export var ammo_stored = 15

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	print("entered")
	if body is PlayerCharacter:
		print("body is player")
		if body.has_node("Shooting"):
			body.get_node("Shooting").add_ammo(ammo_stored)
			Global.shoot_enable = true
			# disable the ammo trigger
			set_deferred("monitorable", false)
			set_deferred("monitoring", false)
			# hide the visual
			visible = false
			# play the sound and wait for it to finish
			$AmmoSound.play()
			$AmmoSound.finished.connect(_ammo_sound_finished)

func _ammo_sound_finished():
	# destroy object when sound finishes
	queue_free()
