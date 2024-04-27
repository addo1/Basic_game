extends ShootingBase

class_name ShootingProjectile

@export var bullet_speed = 25
@export var projectile : PackedScene

func _shoot():
    spawn_bullet(projectile, get_shot_origin_transform())
    $ShootSound.play()
    
func spawn_bullet(bullet_prefab, bullet_origin_transform):
    var bullet = bullet_prefab.instantiate()
    # spawn the bullet as a sibling of the parent node (be a child of the parent's parent node)
    get_parent().get_parent().add_child(bullet)
    bullet.global_transform.origin = bullet_origin_transform.origin
    bullet.global_transform.basis = bullet_origin_transform.basis
    bullet.apply_impulse(-global_transform.basis.z * bullet_speed)
    bullet.team = team