extends Node

@export var start_open = false

func _ready():
    if start_open:
        $AnimationPlayer.play("open", 1.0, true)

func open_door():
    $AnimationPlayer.play("open")

func close_door():
    $AnimationPlayer.play("close")