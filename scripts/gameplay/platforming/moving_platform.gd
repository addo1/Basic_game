extends Node3D

# component that follows the defined path
@onready var path_follow = $PathFollow3D
# timer to control the platform's wait time at the end of the path
@onready var timer = $Timer

# speed of the platform
@export var speed = 5.0
# if the platform should loop its' movement when it reaches the end of the path
@export var loop = true
# how many times should the platform loop its' movement (if set to 0 - infinite)
@export var loop_count = 0
# how many times the platform has looped its' movement
var current_loops = 0
# if the platform is moving
@export var is_moving = false
# the direction of the platform's movement
# can be either 1 or -1
@export var direction = 1

# the time the platform should wait at the end of the path
@export var platform_wait_time = 2.0

func _ready():
	# make sure the direction is set to 1 or -1
	# incase the value was set to something else in the editor
	set_platform_direction(direction)
	timer.timeout.connect(_platform_wait_timeout)

func _physics_process(delta):
	# move the platform when it is set to move and when it's not waiting for the timer to finish
	if is_moving and timer.is_stopped():
		# move the platform along the path
		path_follow.progress += delta * speed * direction
		# check if the platform reached either end of the path
		if path_follow.progress_ratio >= 1.0 or path_follow.progress_ratio <= 0.0:
			_handle_platform_reached_end()

func _flip_direction():
	direction = -direction

func _handle_platform_reached_end():
	# only flip the direction if the platform is set to loop
	# and the loop count does not exceed the limit (or is not infinite)
	if loop and (loop_count == 0 or current_loops < loop_count):
		current_loops += 1
		# if the platform is set to wait at the end, stop it and start the timer to resume movement
		if platform_wait_time > 0:
			timer.start(platform_wait_time)
		else:
			_flip_direction()
	else:
		# flip direction when we reach the end
		# even if we stop
		_flip_direction()
		stop_platform()

# fully stop the platform, resetting its' state
func stop_platform():
	is_moving = false
	timer.paused = false
	timer.stop()
	current_loops = 0

# pause the platform
func pause_platform():
	# we set it to stop moving in any case
	is_moving = false
	# if the timer was running, pause it
	if not timer.is_stopped():
		timer.paused = true

# start the movement of the platform
# it will start moving with any direction it was set to
func start_platform():
	is_moving = true

# start the movement of the platform with a specific direction	
func start_moving_with_direction(new_direction):
	set_platform_direction(new_direction)
	start_platform()

# resume the movement of the platform
func resume_platform():
	# if the timer was paused, resume it, but don't move the platform
	# becasue the platform was paused at the end before it flipped its' direction
	# if the timer was not paused, that means the platform was paused in the middle
	# so resume its' movement
	if timer.paused:
		timer.paused = false
	else:
		is_moving = true

# set the movement direction of the platform
# zero or a positive value will move it forwards relative to the defined path
# a negative value will move it backwards
func set_platform_direction(new_direction):
	if new_direction < 0:
		direction = -1
	else:
		direction = 1

# set the time the platform should wait at the end of the path
func set_platform_wait_time(new_wait_time):
	platform_wait_time = new_wait_time

# set the speed of the platform
func set_platform_speed(new_speed):
	speed = new_speed

func _platform_wait_timeout():
	_flip_direction()
	is_moving = true
