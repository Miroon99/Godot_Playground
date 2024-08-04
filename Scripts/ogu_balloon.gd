extends Area2D

var random_sprite = randi() % 6 + 1
var balloons_path = "res://sprites/ogu_balloon/ogu_balloon_%d.png" % random_sprite

var balloon_sprite = load(balloons_path)
var hasUsed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$BallonSprite.texture = balloon_sprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handleMove(delta)
	
func _on_body_entered(body):
	if !body.is_in_group("player") and hasUsed:
		return

	hasUsed = true
	body.setRestingAt(self)
	
var moveSpeed = randi() % 100 + 50
func handleMove(delta):
	if !hasUsed:
		return
	
	position.x += moveSpeed * delta
	
func getRestingPosition():
	return $resting_area.global_position
	
func getFocusObject():
	return $focus_area
	
