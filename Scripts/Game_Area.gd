extends Node2D

var player_obj = preload("res://playable/bird.tscn")
var player = player_obj.instantiate()

@onready var cannon = $Cannon

var gameRunning: bool
var gameOver: bool
var scroll = 0
var score = 0
var SCROLL_SPEED: int = 3
var screenSize: Vector2i
var groundHeight: int
var pipes: Array
const PIPE_DELAY: int = 100
const PIPE_RANGE: int = 200
const X_AXIS_BIRD_FLYING = 400

func _ready():
	screenSize = get_window().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if gameRunning:
		scroll += SCROLL_SPEED
		if scroll >= screenSize.x:
			scroll = 0
		$Ground.position.x = -scroll
		
		if $Cannon.position.x > -60:
			$Cannon.position.x = -scroll
		
		
	if Input.is_action_just_pressed("cannon_fire"):
		player.position = cannon.getPlayerSpawnPosition()
		player.rotation = cannon.getBodyRotation()
		add_child(player)
		move_child(player, 0)
		player.flyFromCannonFire(1000)
	
func moveGround():
	gameRunning = true
	
func stopGround():
	gameRunning = false

func _physics_process(delta):
	if player.position.x >= X_AXIS_BIRD_FLYING:
		player.velocity.x = 0
		moveGround()
	
	if player.is_on_floor():
		stopGround()

