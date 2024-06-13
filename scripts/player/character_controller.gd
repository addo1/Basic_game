extends CharacterBody3D

class_name PlayerCharacter

# default gravity value
var GRAVITY = 9.8

var minus = false

# the node that tells which direction the player is facing
# typically it's the camera and is the child of this node
@export var direction_driver : Node3D
# the visual representation of the player
# typically it's a child of this node
@export var player_model : Node3D

# the velocity at which the player jumps
@export var jump_velocity = 3.5
# whether the player wants to jump
# it's tracked because we might want to jump when we can't
var wants_to_jump = false

# the input vector that tells the player's movement direction
var input_vector = Vector2.ZERO
# the maximum speed the player can move
@export var max_speed = 5
# the acceleration applied when reaching target movement velocity
@export var acceleration = 2
# the rotation rate of the player's model (radians)
@export var rotation_rate = 2*PI
# should rotate the controller with the velocity?
@export var rotate_with_velocity = true
# should rotate the controller with where the direction driver is facing?
@export var rotate_with_direction_driver = false

var was_launched = false

var can_control_velocity = true

var is_dead = false

signal jumped
signal landed

func _ready():
	if has_node("Health"):
		get_node("Health").died.connect(_character_died)

func _physics_process(delta):
	# get separate velocity for the ground plane movement
	var xz_velocity = velocity
	xz_velocity.y = 0

	# calculate the forward and right directions in world space based on direction driver
	var world_forward_direction = Plane.PLANE_XZ.project(direction_driver.global_transform.basis.z).normalized()
	var world_right_direction = Plane.PLANE_XZ.project(direction_driver.global_transform.basis.x).normalized()
	#calculate target velocity and frame delta velocity
	var target_velocity = (world_forward_direction * input_vector.y + world_right_direction * input_vector.x) * max_speed
	if is_dead:
		if not minus:
			get_node("/root/Game/FPSLevel/FPSCharacter/CoinStash_score").score_in_stash = get_node("/root/Game/FPSLevel/FPSCharacter/CoinStash_score").score_in_stash * 0.8
			minus = true
		target_velocity = Vector3.ZERO
	# calculate the delta of current horizontal velocity and the velocity we want to reach
	var delta_velocity = target_velocity - xz_velocity
	var final_acceleration = acceleration
	if delta_velocity.normalized().dot(xz_velocity.normalized()) < 0:
		# if the player is moving in the opposite direction than we want, apply a higher acceleration
		# this is to make the player stop faster
		final_acceleration *= 2
	# calculate the frame delta velocity
	var frame_delta_velocity = delta_velocity * final_acceleration * delta
	# if we overshoot the target velocity this frame, cap the frame delta to reach the target
	if delta_velocity.length_squared() < frame_delta_velocity.length_squared():
		frame_delta_velocity = delta_velocity;
	
	if not can_control_velocity:
		frame_delta_velocity.x = 0
		frame_delta_velocity.z = 0

	# apply gravity separately if on floor
	if not is_on_floor():
		frame_delta_velocity.y = -GRAVITY * delta
	elif is_on_floor():
		if wants_to_jump and velocity.y < jump_velocity:
			# if we're on the floor and the player wants to jump, jump
			# this check is necessary mainly for when players press the jump button
			# right before they hit the ground
			attempt_jump()

	velocity += frame_delta_velocity

	# rotates the player model towards the direction of movement
	# only if the player is moving
	if rotate_with_velocity and target_velocity != Vector3.ZERO:
		_rotate_towards_direction(target_velocity.normalized(), delta)

	if rotate_with_direction_driver:
		_rotate_towards_direction(-world_forward_direction, delta)

	var was_on_floor = is_on_floor()
	#moves the character according to the velocity
	move_and_slide()

	# post movement checks
	if is_on_floor():
		if not was_on_floor:
			landed.emit()
		# if we land after launching with air control disabled, re-enable it
		if was_launched:
			was_launched = false
			can_control_velocity = true
		

func attempt_jump():
	if _can_jump():
		velocity = get_real_velocity()
		velocity.y = jump_velocity
		jumped.emit()
		# we don't want to jump again until the player releases the jump button
		wants_to_jump = false

func _can_jump():
	return is_on_floor() and not is_dead

func _rotate_towards_direction(direction, delta):
	if direction.length_squared() > 0:
			# calculate the angle between the player's current direction and the target direction
			var angle = global_transform.basis.z.signed_angle_to(-direction, Vector3.UP)
			# calculate delta angle for this frame
			var delta_angle = sign(angle) * delta * rotation_rate
			# don't overshoot the target angle
			if(abs(delta_angle) > abs(angle)):
				delta_angle = angle
			# apply the rotation to the player model
			#global_transform = global_transform.rotated(Vector3.UP, delta_angle)
			rotate(Vector3.UP, delta_angle)

# input functions
func input_jump(jump):
	wants_to_jump = jump

func set_input_vector(input):
	input_vector = input

func launch_character(launch_velocity, allow_air_control = true):
	velocity = launch_velocity
	was_launched = true
	can_control_velocity = allow_air_control

func _character_died():
	is_dead = true
