extends Label

var time = 0
var time_on = true

func _process(delta):
	if (time_on):
		time += delta
	var mils = fmod(time, 1)*1000
	var secs = fmod(time, 60)
	var mins = fmod(time, 60*60)/60
	var time_passed = "%02d : %02d . %03d" % [mins, secs, mils]
	text = time_passed
	if mins > 0.1:
		get_node("/root/Game/FPSLevel/LossTracker").trigger_loss()
pass
