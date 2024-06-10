extends ProgressBar

@export var health_node : Node

func _ready():
	if health_node != null:
		health_node.health_changed.connect(_on_health_changed)
		_on_health_changed(health_node.current_health, 0, health_node.max_health)

func _on_health_changed(health, _delta, max_health):
	# ratio is a percentage value of the progress bar (0-1)
	# using it instead of the value property makes us independent
	# from the min and max values of the progress bar
	ratio = (health as float) / max_health
