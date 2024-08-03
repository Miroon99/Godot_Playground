extends TextureProgressBar

# Called when the node enters the scene tree for the first time.
var player
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func attachPlayer(player):
	self.player = player
	self.player.energyChanged.connect(update)
	update(self.player.currentEnergy)
	
func update(newEnergy):
	value = newEnergy
	
