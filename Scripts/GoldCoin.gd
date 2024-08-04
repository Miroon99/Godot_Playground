extends Area2D

func _ready():
	$AnimatedSprite2D.play("default")
 

func _on_body_entered(body):
	if !body.is_in_group("player"):
		return
		
	self.visible = false
	body.collectCoin(1)
	$CoinCollectedSound.play()
	$CoinCollectedSound.finished.connect(queue_free)

