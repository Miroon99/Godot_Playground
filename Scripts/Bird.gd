extends CharacterBody2D
@onready var birdSprite2D = $BirdSprite2D
var isGroundMoving = false
var isFlap = false
var coinsCollected: int = 0

#reset position
var default_position = Vector2(51, 296)
var default_rotation = 0

@export var maxEnergy = 100
@onready var currentEnergy = maxEnergy
signal energyChanged
signal birdDead
signal isRestingSignal

var isResting = false
var onRestingVelocity: Vector2
var currentRestingParentObject: Node2D

func _ready():
	birdSprite2D.play("idle")
	motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dead:
		birdSprite2D.play("dead")
	
func _input(event):
	pass
		
var gravity = 300
var flap_energy = 0
var max_flap_energy = 20
var gradual_speed = 150
func _physics_process(delta):
	if isResting:
		handleResting(delta)
		return
	
	handleGravity(delta)
	handleFlap(delta)
	look_at(transform.origin + velocity)
	move_and_slide()

const energy_per_flap = 0.01
func handleFlap(delta):
	if dead or currentEnergy <= 0:
		return

	if Input.is_action_pressed("cannon_fire"):
		birdSprite2D.play("flap")
		flap_energy += gradual_speed * delta
		flap_energy = clamp(flap_energy, 0, max_flap_energy)
		velocity.y -= flap_energy
		velocity.x += 100 * delta
		velocity.x = clamp(velocity.x, 0, 600)
		currentEnergy -= 10 * delta
		addEnergy(-energy_per_flap)
		
	if Input.is_action_just_released("cannon_fire"):
		birdSprite2D.play("idle")
		flap_energy = 0
		
var play = false
func flyFromCannonFire(cannon_force):
	var angle_radians = deg_to_rad(rotation_degrees)
	var force_vector = Vector2(cos(angle_radians), sin(angle_radians))
	velocity = force_vector * cannon_force
	play = true

var dead = false
func handleGravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = clamp(velocity.y, -1500, 600)
	elif play:
		dead = true
		play = false
		$hitGroundPlayer.play()
		birdDead.emit()
	elif !play:
		velocity.x = move_toward(velocity.x, 0, 10)

func addEnergy(amount):
	currentEnergy += amount
	energyChanged.emit(currentEnergy)
		
func collectCoin(count: int):
	coinsCollected += count
	get_parent().updateCollectedCoin(coinsCollected)
	
func setRestingAt(parentObject):
	isResting = true
	onRestingVelocity = velocity
	rotation = 0
	position = parentObject.getRestingPosition()
	currentRestingParentObject = parentObject
	var restTimer = $restTimer
	restTimer.wait_time = randi() % 7 + 3
	restTimer.start()
	isRestingSignal.emit(true, parentObject.getFocusObject())
	
var charging_speed = 1
func handleResting(delta):
	if currentRestingParentObject == null:
		return

	addEnergy(charging_speed * delta)
	position = currentRestingParentObject.getRestingPosition()

func _on_rest_timer_timeout():
	$restTimer.stop()
	isRestingSignal.emit(false, null)
	isResting = false
	velocity = Vector2(500, 0)
	
