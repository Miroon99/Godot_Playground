extends Node2D

var player_obj = preload("res://playable/bird.tscn")
var player = player_obj.instantiate()
var energybar_obj = preload("res://UI/EnergyBarUI.tscn")
var energybar = energybar_obj.instantiate()
var powerup_obj = preload("res://playable/batteryPowerup.tscn")
var ground_obj = preload("res://playable/ground.tscn")
var restartUIobj = preload("res://UI/dead_restart/restart_UI.tscn")

@onready var cannon = $Cannon
@onready var main_camera = $Camera2D
@onready var coinCountLabel = $CanvasLayer/Label

var gameRunning: bool = false
var gameOver: bool
var scroll = 0
var screenSize: Vector2i
var groundHeight: int
var currentGround: Node
var upcomingGround: Node
var futureGround: Node
var crowCrowdPerArea = 1
var placed_positions = []

var goldCoin = preload("res://playable/goldcoin.tscn")
var crow = preload("res://playable/crow.tscn")

func _ready():
	screenSize = get_window().size
	addGround()
	coinCountLabel.text = "--- "
	
func addGround():
	const bottomScreenY = 622
	currentGround = ground_obj.instantiate()
	currentGround.position = Vector2(0,bottomScreenY)
	
	upcomingGround = ground_obj.instantiate()
	upcomingGround.position = Vector2(currentGround.getEndPosition().x,bottomScreenY)
	
	futureGround = ground_obj.instantiate()
	futureGround.position = Vector2(upcomingGround.getEndPosition().x,bottomScreenY)
	
	add_child(currentGround)
	add_child(upcomingGround)
	add_child(futureGround)
	
	
func moveGroundForward(counter):
	pass

func updateCollectedCoin(count: int):
	coinCountLabel.text = "%d " % count
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handleMainCamera()
	
	if Input.is_action_just_pressed("cannon_fire"):
		handleCannonFire()
		
func handleCannonFire():
	if gameRunning:
		return
		
	player.position = cannon.getPlayerSpawnPosition()
	player.rotation = cannon.getBodyRotation()
	add_child(player)
	move_child(player, 100)
	move_child(cannon, 90)
	
	cannon.doShoot()
	player.flyFromCannonFire(1000)
	gameRunning = true
	energybar.attachPlayer(player)
	player.birdDead.connect(showRestartButton)
	$CanvasLayer.add_child(energybar)

func handleMainCamera():
	if !gameRunning:
		return

	var camera_width = main_camera.get_viewport_rect().size.x
	var camera_height = main_camera.get_viewport_rect().size.y
	
	var x_margin = 100
	var camera_position_x = (player.global_position.x + camera_width * 0.5) - x_margin
	
	var max_camera_to_ground = ($Ground.global_position.y + 30) - camera_height * 0.5
	var clamped_camera_position_y = clamp(player.global_position.y, player.global_position.y, max_camera_to_ground)
	
	main_camera.position = Vector2(camera_position_x, clamped_camera_position_y)

func _physics_process(delta):
	if main_camera.position.x > upcomingGround.getMidPosition().x:
		currentGround.position.x = futureGround.getEndPosition().x
		_generateCoins(currentGround.position.x)
		_generateCrows(currentGround.position.x)
		_generatePowerUps(currentGround.position.x)
		var temporaryGround = futureGround
		futureGround = currentGround
		currentGround = upcomingGround
		upcomingGround = temporaryGround
		#
#func _generateCoins(coinX):
	#for  i in range (6) :
		#var gold_coin = goldCoin.instantiate()
		#var coin_rand_x = randf_range(coinX, coinX  + screenSize.length())
		#var coin_rand_y = randf_range(150,450)
		#gold_coin.position = Vector2(coin_rand_x,coin_rand_y)
		#add_child(gold_coin)
		#
#func _generateCrows(coinX):
	#for  i in range (crowCrowdPerArea) :
		#var crowObj = crow.instantiate()
		#var randX = randf_range(coinX, coinX  + screenSize.length())
		#var randY = randf_range(200,600)
		#crowObj.position = Vector2(randX,randY)
		#add_child(crowObj)
#
#func _generatePowerUps(startX):
	#var maxPowerups = randi() % 3
	#for i in range(maxPowerups):
		#var battery = powerup_obj.instantiate()
		#var spawnX = randf_range(startX, startX + screenSize.length())
		#var spawnY = randf_range(-300, 550)
		#battery.position = Vector2(spawnX, spawnY)
		#add_child(battery)
		
func _generateCoins(coinX):
	for i in range(6):
		var gold_coin = goldCoin.instantiate()
		var position = _get_non_overlapping_position(coinX, 150, 450)
		gold_coin.position = position
		placed_positions.append(position)
		add_child(gold_coin)

func _generateCrows(coinX):
	for i in range(crowCrowdPerArea):
		var crowObj = crow.instantiate()
		var position = _get_non_overlapping_position(coinX, 0, 400)
		crowObj.position = position
		placed_positions.append(position)
		add_child(crowObj)

func _generatePowerUps(startX):
	var maxPowerups = randi() % 3
	for i in range(maxPowerups):
		var battery = powerup_obj.instantiate()
		var position = _get_non_overlapping_position(startX, -300, 550)
		battery.position = position
		placed_positions.append(position)
		add_child(battery)

func _get_non_overlapping_position(startX, minY, maxY):
	var max_attempts = 100
	var position = Vector2()
	for attempt in range(max_attempts):
		var spawnX = randf_range(startX, startX + screenSize.length())
		var spawnY = randf_range(minY, maxY)
		position = Vector2(spawnX, spawnY)
		if _is_position_valid(position):
			return position
	# If all attempts fail, return the last position (should be rare)
	return position

func _is_position_valid(position):
	var min_distance = 70  # Minimum distance to consider as non-overlapping
	for placed_position in placed_positions:
		if position.distance_to(placed_position) < min_distance:
			return false
	return true
	
func showRestartButton():
	var restartUI = restartUIobj.instantiate()
	restartUI.restartAction = gotoRestartScene
	restartUI.homeAction = gotoHomeScene
	$CanvasLayer.add_child(restartUI)

func gotoHomeScene():
	get_tree().change_scene_to_file("res://playable/Menu.tscn")
	
func gotoRestartScene():
	get_tree().reload_current_scene()
