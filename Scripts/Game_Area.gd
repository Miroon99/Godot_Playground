extends Node2D

var player_obj = preload("res://playable/bird.tscn")
var player = player_obj.instantiate()

@onready var cannon = $Cannon

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("cannon_fire"):
		player.position = cannon.getPlayerSpawnPosition()
		player.rotation = cannon.getBodyRotation()
		add_child(player)
		move_child(player, 0)
		player.flyFromCannonFire(1000)
