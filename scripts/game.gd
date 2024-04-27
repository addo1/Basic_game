extends Node

@export var initial_scene : PackedScene = null
var current_scene : PackedScene = null
var current_scene_instance = null

func _ready():
	load_initial_scene()

func load_scene_and_set_current(scene):
	if current_scene:
		clear_current_scene()
	var scene_instance = scene.instantiate()
	set_current_scene(scene, scene_instance)

func clear_current_scene():
	if current_scene_instance:
		current_scene_instance.queue_free()
	current_scene_instance = null
	current_scene = null

func set_current_scene(scene, scene_instance):
	add_child(scene_instance)
	current_scene = scene
	current_scene_instance = scene_instance

func reload_current_scene():
	if current_scene:
		load_scene_and_set_current(current_scene)

func load_initial_scene():
	if initial_scene:
		load_scene_and_set_current(initial_scene)
