extends Node3D

# how much rotation to apply per mouse movement
@export var camera_sensitivity = 0.1
# maximum camera pitch in degrees
@export var max_pitch = 89;

# offset from the parent node
var local_offset = Vector3.ZERO

func _ready():
	# capture the mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# calculate the offset from the parent node to later apply it every frame
	local_offset = global_transform.origin - get_parent().global_transform.origin

func _process(_delta):
	# move the node's origin to the parent's origin plus the offset
	global_position = get_parent().global_transform.origin + local_offset

func rotate_camera(mouse_motion):
	rotation_degrees.y -= mouse_motion.x * camera_sensitivity
	rotation_degrees.x -= mouse_motion.y * camera_sensitivity
	rotation_degrees.x = clamp(rotation_degrees.x, -max_pitch, max_pitch)
