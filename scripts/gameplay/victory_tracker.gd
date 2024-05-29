extends Node

@export var player : PlayerCharacter
@export var victory_screen : VictoryScreen

func trigger_victory():
	victory_screen.announce_victory()
	player.get_node("Input").set_handle_input(false)
