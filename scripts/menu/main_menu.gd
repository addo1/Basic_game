extends Control

var click_enable: bool = false

func show_level_select():
	$TitleScreen.visible = false
	$LevelSelect.visible = true
	var anim_player = $LevelSelect/AnimationPlayer
	click_enable = true
	anim_player.play("Splash")
	
	
func _input(event):
	if (event is InputEventKey and click_enable):
		start_fps_level()
		
func start_fps_level():
	var scene = load("res://scenes/example_levels/fps_level.tscn")
	get_parent().load_scene_and_set_current(scene)


func exit_game():
	get_tree().quit()


func _on_animation_player_animation_finished(anim_name):
	start_fps_level()
	pass # Replace with function body.
