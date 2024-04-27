extends Control

func show_level_select():
	$TitleScreen.visible = false
	$LevelSelect.visible = true

func start_fps_level():
	var scene = load("res://scenes/example_levels/fps_level.tscn")
	get_parent().load_scene_and_set_current(scene)

func start_third_person_level():
	var scene = load("res://scenes/example_levels/third_person_level.tscn")
	get_parent().load_scene_and_set_current(scene)

func start_platformer_level():
	var scene = load("res://scenes/example_levels/platformer_level.tscn")
	get_parent().load_scene_and_set_current(scene)

func exit_game():
	get_tree().quit()
