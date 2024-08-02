extends CharacterBody2D
@onready var birdSprite2D = $BirdSprite2D
var isGroundMoving = false
var isFlap = false
var freeze = true
var rotating = true
var velocityCopy: Vector2

#reset position
var default_position = Vector2(51, 296)
var default_rotation = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	pass
		
var gravity = 300
var flap_energy = 0
var max_flap_energy = 20
var gradual_speed = 150
func _physics_process(delta):
	handleGravity(delta)
	handleFlap(delta)
	
	#velocity.y = clamp(velocity.y, -400, 500)
	#look_at(transform.origin + velocity)
		
	move_and_slide()

func handleFlap(delta):
	if not is_on_floor() and velocity.y < 0 and !isFlap:
		velocity.y = move_toward(velocity.y, 0, 10)

	if Input.is_action_pressed("bird_push"):
		freeze = false
		isFlap = true
		birdSprite2D.play("flap")
		flap_energy += gradual_speed * delta
		flap_energy = clamp(flap_energy, 0, max_flap_energy)
		velocity.y -= flap_energy
		
	if Input.is_action_just_released("bird_push"):
		isFlap = false
		birdSprite2D.play("idle")
		flap_energy = 0
		
func flyFromCannonFire(cannon_force):
	var angle_radians = deg_to_rad(rotation_degrees)
	var force_vector = Vector2(cos(angle_radians), sin(angle_radians))
	velocity = force_vector * cannon_force

func handleGravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
