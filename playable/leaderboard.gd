extends Node2D


var player_name
var score = randi() % 101
@onready var leaderboard_score = preload("res://addons/silent_wolf/Scores/Leaderboard.tscn")



func _on_button_pressed():
	var inputText = $LineEdit.text
	player_name = inputText
	SilentWolf.Scores.save_score(player_name, score)
	get_tree().change_scene_to_packed(leaderboard_score)
