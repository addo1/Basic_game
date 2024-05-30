extends Node

@export var max_health = 100.0
var current_health = max_health

var is_dead = false
var is_blocking = false
# the "team" of the health owner
# members of the same team can't damage each other
# unless friendly fire is allowed
# team 0 is neutral and can damage everyone
@export var team = 0

signal health_changed(health, delta, max_health)
signal died()

func _ready():
	current_health = max_health

# applies damage to the health
# returns true if the damage was applied
# returns false if the damage was not applied
func apply_damage(damage, damage_team = 0):
	# don't deal damage if it's negative or the character is already dead
	if damage < 0 or current_health <= 0 or is_blocking:
		return false
	# don't damage if the team is the same and we don't allow friendly fire
	if damage_team != 0 and damage_team == team:
		return false
	current_health -= damage
	# if health recheas 0 or less, the character dies
	if current_health <= 0:
		current_health = 0
		is_dead = true
		emit_signal("died")
	emit_signal("health_changed", current_health, -damage, max_health)
	return true

func heal(amount):
	# don't heal if it's negative or the character is dead
	if amount < 0 or is_dead:
		return
	current_health += amount
	# if health reaches max_health, don't go over it
	if current_health > max_health:
		current_health = max_health
	emit_signal("health_changed", current_health, amount, max_health)
