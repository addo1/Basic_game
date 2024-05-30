extends Area3D

# how much the pickup will heal
@export var heal_amount = 10

func _ready():
	# connect the body_entered signal to the _on_pickup_body_entered function when starting play
	body_entered.connect(_on_pickup_body_entered)

func _on_pickup_body_entered(body):
	# check if the body entered has the Health node
	# if it doesn't, do nothing
	if body.has_node("Health"):
		var health_node = body.get_node("Health")
		if health_node != null:
			health_node.heal(heal_amount)
			# disable the health trigger
			set_deferred("monitoring", false)
			set_deferred("monitorable", false)
			# hide the visual
			visible = false
			# play the health sound and wait for it to finish
			$HealthSound.play()
			$HealthSound.finished.connect(_on_health_sound_finished)

func _on_health_sound_finished():
	# destroy the pickup when sound is finished
	queue_free()
