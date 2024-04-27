extends RigidBody3D

# damage that the bullet will deal
@export var damage = 10
# how long the bullet will last before being destroyed
@export var lifetime = 2.0
# maximum allowed bounces (collisions) before being destroyed
@export var max_bounces = 3
var bounces = 0

# team of the bullet, used to determine if the bullet can damage the target
var team = 0
# variable that tracks if the bullet is pending destruction
var pending_destroy = false
 
func _ready():
    body_entered.connect(_on_bullet_body_entered)
    if lifetime > 0:
        var lifetime_timer = Timer.new()
        lifetime_timer.wait_time = lifetime
        lifetime_timer.timeout.connect(_on_lifetime_timeout)
        add_child(lifetime_timer)
        lifetime_timer.start()

func _on_bullet_body_entered(body):
    bounces += 1
    # if the body has a Health node, apply damage to it
    if body.has_node("Health"):
        var health_node = body.get_node("Health")
        if health_node.apply_damage(damage):
            destroy_bullet()
            return
    # if no Health node was found, destroy the bullet if it reached the maximum bounces
    if bounces >= max_bounces:
        destroy_bullet()
        return
    # otherwise just play the hit particles
    _play_hit_particles_and_sound()

func _on_lifetime_timeout():
    destroy_bullet()

# disables the bullet and waits for the idle particles to finish before destroying everything
func destroy_bullet():
    # if the bullet is already pending destruction, return
    if pending_destroy:
        return
    # mark that the bullet is about to be destroyed
    pending_destroy = true
    # disalbe the emission of idle particles and wait for it to finish
    $IdleParticles.emitting = false
    $IdleParticles.finished.connect(_idle_particles_finished)
    # hide the bullet
    $CSGSphere3D.visible = false
    # play hit particles
    _play_hit_particles_and_sound()
    # disable the collision
    collision_layer = 0
    collision_mask = 0

func _play_hit_particles_and_sound():
    $HitParticles.restart()
    $HitParticles.emitting = true
    $HitSound.play()

func _idle_particles_finished():
    queue_free()