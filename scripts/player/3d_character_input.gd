extends Node

@export var controlled_character : Node3D
@export var shooting_node : ShootingBase
@export var camera : Node3D
var input_vector = Vector2.ZERO

var handle_input = true

func _input(event):
	if not handle_input:
		return
	
	if controlled_character == null:
		return

	if event.is_action_pressed("jump"):
		controlled_character.input_jump(true)
		controlled_character.attempt_jump()
	elif event.is_action_released("jump"):
		controlled_character.input_jump(false)

	if event.is_action_pressed("right"):
		input_vector.x += Vector2.RIGHT.x
	elif event.is_action_pressed("left"):
		input_vector.x += Vector2.LEFT.x
	elif event.is_action_released("right"):
		input_vector.x -= Vector2.RIGHT.x
	elif event.is_action_released("left"):
		input_vector.x -= Vector2.LEFT.x

	if event.is_action_pressed("forward"):
		input_vector.y += Vector2.UP.y
	elif event.is_action_pressed("back"):
		input_vector.y += Vector2.DOWN.y
	elif event.is_action_released("forward"):
		input_vector.y -= Vector2.UP.y
	elif event.is_action_released("back"):
		input_vector.y -= Vector2.DOWN.y

	controlled_character.set_input_vector(input_vector)

	if shooting_node != null:
		if event.is_action_pressed("shoot"):
			shooting_node.set_wants_to_shoot(true)
		elif event.is_action_released("shoot"):
			shooting_node.set_wants_to_shoot(false)

	if event is InputEventMouseMotion and camera != null:
		camera.rotate_camera(event.relative)

func set_handle_input(value):
	handle_input = value
	input_vector = Vector2.ZERO
	if not handle_input:
		if controlled_character != null:
			controlled_character.set_input_vector(Vector2.ZERO)
			controlled_character.input_jump(false)
		if shooting_node != null:
			shooting_node.set_wants_to_shoot(false)
		
