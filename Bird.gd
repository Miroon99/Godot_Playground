extends CharacterBody2D
@onready var birdSprite2D = $BirdSprite2D
var isFlap = false
var falling_speed = 50 * 0
var flap_speed = 80 * 0
var freeze = true
var rotating = true

#reset position
var default_position = Vector2(51, 296)
var default_rotation = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cannon_rotation(delta)
	
func _input(event):
	if event is InputEventKey and event.keycode == KEY_R and event.pressed:
		resetBird()
		
var gravity = 300
var flap_energy = 0
var max_flap_energy = 20
var gradual_speed = 150
func _physics_process(delta):
	handleCannonFire(delta)
	handleGravity(delta)
	handleFlap(delta)
	
	velocity.y = clamp(velocity.y, -400, 500)
	look_at(transform.origin + velocity)
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
	
func resetBird():
	freeze = true
	rotating = true
	velocity = Vector2(0, 0)
	rotation_degrees = default_rotation
	position = default_position

var max_rotate = 90
var min_rotate = -90
var rotate_speed = 100
var rotate_direction = 1
func cannon_rotation(delta):
	if rotating and freeze:
		if rotation_degrees <= min_rotate:
			rotate_direction = 1
		elif rotation_degrees >= max_rotate:
			rotate_direction = -1
		
		rotation_degrees += 50 * delta * rotate_direction

var cannon_force = 1000
func handleCannonFire(delta):
	if Input.is_action_just_pressed("cannon_fire"):
		freeze = false
		rotating = false
		var angle_radians = deg_to_rad(rotation_degrees)
		var force_vector = Vector2(cos(angle_radians), sin(angle_radians))
		velocity = force_vector * cannon_force

func handleGravity(delta):
	if freeze:
		return
		
	if not is_on_floor() and velocity.y >= 0 and !isFlap:
		velocity.y += gravity * delta
