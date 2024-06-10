extends Control

class_name VictoryScreen

func _ready():
	visible = false

func announce_victory():
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func main_menu_pressed():
	get_parent().get_parent().load_initial_scene()

func play_again_pressed():
	get_parent().get_parent().reload_current_scene()
