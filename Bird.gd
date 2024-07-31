extends CharacterBody2D
@onready var birdSprite2D = $BirdSprite2D
var isFlap = false
var falling_speed = 50 * 0
var flap_speed = 80 * 0
var freeze = false

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
	if event is InputEventKey and event.keycode == KEY_SPACE:
		isFlap = event.is_pressed()
		
	if event is InputEventKey and event.keycode == KEY_R and event.pressed:
		resetBird()
		
var gravity = 300
var push_energy = 0
var max_push_energy = 20
var gradual_speed = 150
func _physics_process(delta):
	velocity.x = 100
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
		push_energy += gradual_speed * delta
		push_energy = clamp(push_energy, 0, max_push_energy)
		velocity.y -= push_energy
		
	if Input.is_action_just_released("bird_push"):
		isFlap = false
		birdSprite2D.play("idle")
		push_energy = 0
	
func resetBird():
	freeze = true
	velocity = Vector2(0, 0)
	rotation_degrees = default_rotation
	position = default_position
	
func handleGravity(delta):
	if freeze:
		return
		
	if not is_on_floor() and velocity.y >= 0 and !isFlap:
		velocity.y += gravity * delta
