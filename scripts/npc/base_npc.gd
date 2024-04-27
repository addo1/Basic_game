extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

@export var movement_speed = 5.0

@export var is_patrolling = false
@export var patrol_points: Array[Node3D]
@export var current_patrol_point = 0

@export var can_aggro = false
@export var aggro_range = 10.0
var chased_target = null

var is_dead = false

func _ready():
	if has_node("Health"):
		get_node("Health").died.connect(_on_died)

	nav_agent.velocity_computed.connect(_on_velocity_computed)
	nav_agent.navigation_finished.connect(_on_navigation_finished)
	var setup_lambda = func setup(tree):
		await tree.physics_frame
		_init_navigation()
	setup_lambda.call_deferred(get_tree())

	if can_aggro:
		var area = Area3D.new()
		var collision = CollisionShape3D.new()        
		add_child(area)
		area.body_entered.connect(_on_aggro_range_entered)
		area.collision_layer = 0
		area.collision_mask = 16
		area.add_child(collision)
		collision.shape = SphereShape3D.new()
		collision.shape.radius = aggro_range


func _init_navigation():
	if is_patrolling:
		_set_navigation_target(patrol_points[current_patrol_point].global_transform.origin)

func _physics_process(_delta):
	if is_dead:
		return

	if chased_target != null:
		_set_navigation_target(chased_target.global_position)
	_process_movement()

func _on_velocity_computed(safe_velocity: Vector3):
	if is_dead:
		return
	velocity = safe_velocity
	move_and_slide()

func _choose_next_patrol_point_index(current_point_index, patrol_point_num):
	if current_point_index + 1 >= patrol_point_num:
		return 0
	else:
		return current_point_index + 1

func _process_movement():
	var next_path_position: Vector3 = nav_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * movement_speed
	if nav_agent.avoidance_enabled:
		nav_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_navigation_finished():
	if is_patrolling:
		current_patrol_point = _choose_next_patrol_point_index(current_patrol_point, patrol_points.size())
		_set_navigation_target(patrol_points[current_patrol_point].global_transform.origin)

func _set_navigation_target(target):
	nav_agent.set_target_position(target)

func _on_aggro_range_entered(body):
	if body is CharacterBody3D:
		chased_target = body
		_set_navigation_target(chased_target.global_position)

func launch_character(launch_velocity, _allow_air_control = true):
	velocity = launch_velocity

func _on_died():
	is_dead = true
	if has_node("DamageArea"):
		var damage_area = get_node("DamageArea")
		damage_area.set_deferred("monitoring", false)
		damage_area.set_deferred("monitorable", false)
		velocity = Vector3.ZERO
