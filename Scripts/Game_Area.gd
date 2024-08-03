extends Node2D

var player_obj = preload("res://playable/bird.tscn")
var player = player_obj.instantiate()

var ground_obj = preload("res://playable/ground.tscn")

@onready var cannon = $Cannon
@onready var main_camera = $Camera2D

var gameRunning: bool
var gameOver: bool
var scroll = 0
var score = 0
var SCROLL_SPEED: int = 3
var screenSize: Vector2i
var groundHeight: int
var currentGround: Node
var upcomingGround: Node
var futureGround: Node

const PIPE_DELAY: int = 100
const PIPE_RANGE: int = 200
const X_AXIS_BIRD_FLYING = 400

func _ready():
	screenSize = get_window().size
	addGround()
	
func addGround():
	const bottomScreenY = 622
	currentGround = ground_obj.instantiate()
	currentGround.position = Vector2(0,bottomScreenY)
		
	upcomingGround = ground_obj.instantiate()
	upcomingGround.position = Vector2(screenSize.length(),bottomScreenY)
	
	futureGround = ground_obj.instantiate()
	futureGround.position = Vector2(screenSize.length() * 2,bottomScreenY)
	
	add_child(currentGround)
	add_child(upcomingGround)
	add_child(futureGround)
	
func moveGroundForward(counter):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handleMainCamera()
	
	if Input.is_action_just_pressed("cannon_fire"):
		player.position = cannon.getPlayerSpawnPosition()
		player.rotation = cannon.getBodyRotation()
		add_child(player)
		move_child(player, 0)
		player.flyFromCannonFire(1000)
		isGameStart = true

var isGameStart = false
func handleMainCamera():
	if !isGameStart:
		return

	var camera_width = main_camera.get_viewport_rect().size.x
	var camera_height = main_camera.get_viewport_rect().size.y
	
	var x_margin = 100
	var camera_position_x = (player.global_position.x + camera_width * 0.5) - x_margin
	
	var max_camera_to_ground = ($Ground.global_position.y + 30) - camera_height * 0.5
	var clamped_camera_position_y = clamp(player.global_position.y, player.global_position.y, max_camera_to_ground)
	
	main_camera.position = Vector2(camera_position_x, clamped_camera_position_y)

func _physics_process(delta):
	if main_camera.position.x > screenSize.length() + currentGround.position.x:
		currentGround.position.x = futureGround.position.x + screenSize.length()
		var temporaryGround = futureGround
		futureGround = currentGround
		currentGround = upcomingGround
		upcomingGround = temporaryGround
		

		print(main_camera.position.x)
		


