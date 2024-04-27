extends Area3D

# area that is supposed to sit on top of the enemy characters
# so that players can jump on them to damage them

var parent_health_node = null

func _ready():
    body_entered.connect(_on_body_entered)
    if get_parent().has_node("Health"):
        parent_health_node = get_parent().get_node("Health")
        parent_health_node.died.connect(_on_died)

func _on_body_entered(body):
    if body is PlayerCharacter:
        # make sure the other body is above us and falling
        if body.global_position.y > global_position.y and body.velocity.y < 0:
            body.launch_character(Vector3.UP * 5)
            if parent_health_node != null:
                parent_health_node.apply_damage(99999)
            $HitSound.play()

func _on_died():
    set_deferred("monitorable", false)
    set_deferred("monitoring", false)