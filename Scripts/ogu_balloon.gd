extends Area2D

var random_sprite = randi() % 6
var balloons_path = "res://sprites/ogu_balloon/ogu_balloon_%d.png" % random_sprite

var balloon_sprite = load(balloons_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	$BallonSprite.texture = balloon_sprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
