extends Node3D

@export var camera_distance = 10

func _process(_delta):
    # every tick set the camera location to a fixed position on the x axis
    global_transform.origin = get_parent().global_transform.origin - Vector3(camera_distance, 0, 0)