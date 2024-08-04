extends Area2D

@export var spritePath: Texture
@export var spriteAnimation: SpriteFrames
@export var bouncing = false
@onready var sound = $collectSound

func _ready():
	pass # Replace with function body.


var maxMovePixel = 5
var originalPosition = position
var moveDirection = 1
var bounceSpeed = 10
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handleBounce(delta)
	
func handleBounce(delta):
	if !bouncing:
		return
	
	var current_y = position.y
	var move_diff = abs(originalPosition.y - current_y)
	if(move_diff > maxMovePixel):
		moveDirection *= -1
		
	position.y += bounceSpeed * delta * moveDirection

var charge_amount = randi() % 10 + 1
func _on_body_entered(body):
	self.visible = false
	$CoinCollectedSound.play()
	body.addEnergy(charge_amount)
	sound.play()
	sound.finished.connect(queue_free)

