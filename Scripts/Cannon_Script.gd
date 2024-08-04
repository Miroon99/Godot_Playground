extends Node2D
# Called when the node enters the scene tree for the first time.

@onready var body = $CannonBody
@onready var playerSpawn = $CannonBody/playerSpawn
@onready var shootAnimation = $CannonBody/cannonShootAnimationSprite

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cannon_rotation(delta)

var min_rotate = -90
var max_rotate = 20
var rotate_speed = 100
var rotate_direction = 1

func cannon_rotation(delta):
	rotation
	if body.rotation_degrees <= min_rotate:
		rotate_direction = 1
	elif body.rotation_degrees >= max_rotate:
		rotate_direction = -1
		
	body.rotation_degrees += 50 * delta * rotate_direction
	
func getBodyRotation():
	return body.rotation
	
func getPlayerSpawnPosition():
	return playerSpawn.global_position
	
func doShoot():
	shootAnimation.play("fire")
	$shootSound.play()
	
