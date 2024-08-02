extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	SilentWolf.configure({
		"api_key" : "iIQCoa3IKd8uCDGTCB3j94ivz4ehcnyL4JKbIFNx",
		"game_id" : "daretofly",
		"log_level" : 1
	})
	SilentWolf.configure_scores({
		"open_scene_on_close" : "res//scenes/MainPage.tscn"
	})
