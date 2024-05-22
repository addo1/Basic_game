extends Area3D

# damage to deal
@export var damage = 25
# if set to true, the provided damage will be delt over one second
# as long as the entity is inside the damage area
@export var is_damage_over_time = false

# how strongly a character has to be launched when being damaged
@export var damage_launch_power = 7

var dot_timer : Timer = null

# list of entities that are currently inside the damage area
var damaged_entities = []

func _ready():
	body_entered.connect(_on_damage_area_body_entered)
	body_exited.connect(_on_damage_area_body_exited)
	if is_damage_over_time:
		create_dot_timer()

func _on_damage_area_body_entered(body):
	# the body has to have a Health node to be able to take damage
	if body.has_node("Health"):
		var health_node = body.get_node("Health")
		# also make sure the body is not already in the damaged_entities list
		if health_node != null and not damaged_entities.has(body):
			# only deal damage if we're not dealing it over time
			if not is_damage_over_time:
				if health_node.apply_damage(damage):
					$DamageSound.play()
					if body is CharacterBody3D:
						# calculate the direction of launch to move the character away from the damage source
						var launch_direction = (body.global_transform.origin - global_transform.origin).normalized()
						# reduce the y component to prevent the character from launching too high
						launch_direction.y = 1
						var launch_velocity = launch_direction.normalized() * damage_launch_power;
						# knock the character back
						if body.has_method("launch_character"):
							body.launch_character(launch_velocity, false)
			# add the body to the list of damaged entities
			damaged_entities.append(body)

func _on_damage_area_body_exited(body):
	# remove the body from the list of damaged entities
	if damaged_entities.has(body):
		damaged_entities.erase(body)

# sets the area damage
func set_damage(damage_value, is_damage_over_time_value):
	damage = damage_value
	is_damage_over_time = is_damage_over_time_value
	if is_damage_over_time:
		if dot_timer == null:
			create_dot_timer()
		dot_timer.start()
	else:
		if dot_timer != null:
			dot_timer.stop()

# creates a damage over time timer
# that deals damage to all entities inside the damage area
# every second
func create_dot_timer():
	dot_timer = Timer.new()
	dot_timer.set_wait_time(1)
	dot_timer.set_one_shot(false)
	dot_timer.timeout.connect(_on_dot_timeout)
	add_child(dot_timer)
	dot_timer.start()

# deals damage when the dot timer times out
func _on_dot_timeout():
	if is_damage_over_time:
		# iterate over all entities that are currently inside the damage area
		for entity in damaged_entities:
			# make sure the entity has a Health node
			if entity.has_node("Health"):
				var health_node = entity.get_node("Health")
				health_node.apply_damage(damage)
