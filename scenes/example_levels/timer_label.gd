extends Label

var time = 0
var time_on = true
var show_3 = false
var show_2 = false
var show_1 = false

func _process(delta):
	if (time_on):
		time += delta
	var mils = fmod(time, 1)*1000
	var secs = fmod(time, 60)
	var mins = fmod(time, 60*60)/60
	var time_passed = "%02d : %02d . %03d" % [mins, secs, mils]
	text = time_passed
	if mins > 5.0:
		get_node("/root/Game/FPSLevel/LossTracker").trigger_loss()
	if mins > 2.0 and not show_3:
		var animation_player = get_node("/root/Game/FPSLevel/show_3minutes/show_plus")
		animation_player.play("show_plus")
		show_3 = true
	if mins > 3.0 and not show_2:
		var animation_player = get_node("/root/Game/FPSLevel/show_2minutes/show_plus")
		animation_player.play("show_plus")
		show_2 = true
	if mins > 4.0 and not show_1:
		var animation_player = get_node("/root/Game/FPSLevel/show_1minutes/show_plus")
		animation_player.play("show_plus")
		show_1 = true
pass
