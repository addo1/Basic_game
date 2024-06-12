extends Node

@export var player : PlayerCharacter
@export var loss_screen : LossScreen

func trigger_loss():
	loss_screen.announce_loss()
	player.get_node("Input").set_handle_input(false)
