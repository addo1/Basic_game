extends Node3D

# at what velocity should the spring launch a character
@export var spring_velocity = 10

func _trigger_area_body_entered(body):
    if body is PlayerCharacter:
        # if the body is a player, wait for them to land on the spring
        body.landed.connect(Callable(self, "_on_player_landed").bindv([body]))

func _trigger_area_body_exited(body):
    if body is PlayerCharacter:
        # if the body is a player, disconnect the landed signal
        body.landed.disconnect(Callable(self, "_on_player_landed").bindv([body]))

func _on_player_landed(body):
    # launch the player when they've landed
    body.velocity.y = spring_velocity
    $SpringSound.play()