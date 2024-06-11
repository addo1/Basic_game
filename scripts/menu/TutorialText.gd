extends Node

@onready var text = $TutorialText

# Called when the node enters the scene tree for the first time.
func _ready():
	text.visible = true
	await get_tree().create_timer(12.0).timeout
	text.visible = false
	 # Replace with function body
