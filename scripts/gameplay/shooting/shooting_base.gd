extends Node3D

class_name ShootingBase

@export var max_ammo = 10
@export var current_ammo = 0
@export var infinite_ammo = false

@onready var ammo_pickup_sound = $AmmoReloadSound

# rate between shots in seconds
@export var shooting_rate = 0.5
# set to true when the player presses the shooting button
var wants_to_shoot = false
# if true, the shooting will continue until the player releases the shooting button
# or runs out of ammo
@export var automatic = false
# if set, the projectile will be spawned at this node's position and rotation
@export var custom_shot_origin_transform : Node3D

@export var team = 0

# internal timer to keep track of shooting rate
var shot_timer : Timer
var reload = true

signal ammo_changed(new_ammo, delta)

func _ready():
	shot_timer = Timer.new()
	shot_timer.wait_time = shooting_rate
	shot_timer.one_shot = true
	shot_timer.autostart = false
	shot_timer.timeout.connect(_shot_timer_timeout)
	add_child(shot_timer)

func attempt_shoot():
	var shoot_enable = Global.shoot_enable
	if can_shoot():
		remove_ammo(1)
		shot_timer.start()
		_shoot()
	else:
		if reload and shoot_enable:
			reload = false
			await get_tree().create_timer(2.0).timeout
			ammo_pickup_sound.play()
			add_ammo(10)
			reload = true

func  _shoot():
	pass

func get_shot_origin_transform():
	if custom_shot_origin_transform != null:
		return custom_shot_origin_transform.global_transform
	return global_transform

func can_shoot():
	# can only shoot when has ammo or shot timer is not active
	return (current_ammo > 0 or infinite_ammo) and not shot_timer.time_left > 0.0

func set_wants_to_shoot(new_value):
	wants_to_shoot = new_value
	if wants_to_shoot:
		# shoot if we can
		attempt_shoot()

func _shot_timer_timeout():
	if automatic and wants_to_shoot:
		# on time out, shoot again if automatic
		attempt_shoot()

func add_ammo(amount):
	print("add ammo")
	current_ammo = min(max_ammo, current_ammo + amount)
	emit_signal("ammo_changed", current_ammo, amount)

func remove_ammo(amount):
	if infinite_ammo:
		return
	current_ammo = max(0, current_ammo - amount)
	emit_signal("ammo_changed", current_ammo, -amount)
