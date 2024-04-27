extends Node

@export var controlled_character : Node3D
var input_vector = Vector2.ZERO

@export var shooting_node : ShootingBase

var handle_input = true

func _input(event):
    if not handle_input:
        return

    if controlled_character == null:
        return

    if event.is_action_pressed("jump") or event.is_action_pressed("forward"):
        controlled_character.input_jump(true)
        controlled_character.attempt_jump()
    elif event.is_action_released("jump") or event.is_action_released("forward"):
        controlled_character.input_jump(false)

    if event.is_action_pressed("right"):
        input_vector.y -= Vector2.UP.y
    elif event.is_action_pressed("left"):
        input_vector.y -= Vector2.DOWN.y
    elif event.is_action_released("right"):
        input_vector.y += Vector2.UP.y
    elif event.is_action_released("left"):
        input_vector.y += Vector2.DOWN.y

    controlled_character.set_input_vector(input_vector)

    if shooting_node != null:
        if event.is_action_pressed("shoot"):
            shooting_node.set_wants_to_shoot(true)
        elif event.is_action_released("shoot"):
            shooting_node.set_wants_to_shoot(false)

func set_handle_input(value):
    handle_input = value
    if not handle_input:
        if controlled_character != null:
            controlled_character.set_input_vector(Vector2.ZERO)
            controlled_character.input_jump(false)
        if shooting_node != null:
            shooting_node.set_wants_to_shoot(false)