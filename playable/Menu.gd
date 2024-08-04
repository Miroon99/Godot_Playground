extends Control
var player_obj = preload("res://playable/biggie.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	player_obj.instantiate()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
