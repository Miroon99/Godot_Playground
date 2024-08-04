extends Control

var restartAction: Callable
var homeAction: Callable
# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/home.pressed.connect(onHomeClick)
	$HBoxContainer/restart.pressed.connect(onRestartClick)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func onRestartClick():
	restartAction.call()
	
func onHomeClick():
	homeAction.call()
