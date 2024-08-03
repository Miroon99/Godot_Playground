extends Area2D

func _ready():
	$AnimatedSprite2D.play("default")

func _on_body_entered(body):
	if body is CharacterBody2D:
		body.collectCoin(1)

