extends Label

@export var shooting_node : ShootingBase
@export var show_max_ammo = false
var max_ammo = 0

func _ready():
    if shooting_node != null:
        shooting_node.ammo_changed.connect(_on_ammo_changed)
        max_ammo = shooting_node.max_ammo
        if shooting_node.infinite_ammo:
            _update_label("∞")
        else:
            _update_label(str(shooting_node.current_ammo), show_max_ammo, str(max_ammo))

func _update_label(ammo_str, show_max = false, max_ammo_str = 0):
    if show_max:
        text = "Ammo: " + ammo_str + " / " + max_ammo_str
    else:
        text = "Ammo: " + ammo_str

func _on_ammo_changed(ammo, _delta):
    _update_label(str(ammo), show_max_ammo, str(max_ammo))
