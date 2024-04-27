extends ShootingBase

class_name ShootingHitScan

# if hit_scan is true, this is the maximum distance the ray will travel
@export var hit_scan_distance = 100
@export var damage = 10

# the collision mask to detect what was shot
@export_flags_2d_physics  var hit_scan_mask : int = 0

func _shoot():
	perform_hit_scan(get_shot_origin_transform(), hit_scan_distance, hit_scan_mask)
	$ShootSound.play()
	
func perform_hit_scan(hit_scan_transform, max_distance, collision_mask):
	# create a ray query parameters object and set its' properties
	var query_parameters = PhysicsRayQueryParameters3D.new()
	query_parameters.from = hit_scan_transform.origin
	query_parameters.to = hit_scan_transform.origin - hit_scan_transform.basis.z * max_distance
	query_parameters.collide_with_bodies = true
	query_parameters.collide_with_areas = false
	query_parameters.hit_from_inside = false
	query_parameters.collision_mask = collision_mask
	# perform the raycast
	var result = get_world_3d().direct_space_state.intersect_ray(query_parameters)
	if not result.is_empty():
		# if something that was hit has the Health node, apply damage to it
		if result.collider.has_node("Health"):
			result.collider.get_node("Health").apply_damage(damage, team)
		# play particles and sound regardless of what was hit
		_play_hit_particles_and_sound(result.position)

func _play_hit_particles_and_sound(hit_location):
	# move the particles and sound to the hit location
	$HitParticles.global_transform.origin = hit_location
	$HitSound.global_transform.origin = hit_location
	$HitParticles.restart()
	$HitParticles.emitting = true
	$HitSound.play()
