extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedCrow.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_body_entered(body):
	self.visible = false
	$CrowStrikeSound.play()
	body.addEnergy(-5)
	$CrowStrikeSound.finished.connect(queue_free)
	pass
