extends Area3D

# signal to tell listeners when the plate is activated
signal activated
# signal to tell listeners when the plate is deactivated
signal deactivated

func _ready():
	# connect the body enter and exit signals to the activation area
	body_entered.connect(_on_plate_body_entered)
	body_exited.connect(_on_plate_body_exited)

func _on_plate_body_entered(_body):
	# the activation signal is emited only if the pressure plate is pressured
	# by the first body, other bodies will not trigger the signal
	if get_overlapping_bodies().size() == 1:
		$AnimatableBody3D.position.y -= 0.1
		$PlateDown.play()
		activated.emit()

func _on_plate_body_exited(_body):
	# the pressure plate is deactivated only if there are no overlapping bodies remaining
	if not has_overlapping_bodies():
		$AnimatableBody3D.position.y += 0.1
		$PlateUp.play()
		deactivated.emit()
