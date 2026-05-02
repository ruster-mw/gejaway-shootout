extends Node

@export var number_of_players : int = 2

@onready var player_scene = load("res://Player.tscn")


func createPlayers() -> void:
	for i in range(number_of_players):
		var player_instance = player_scene.instantiate()
		player_instance.player_id = i + 1
		add_child(player_instance)
	

func _ready() -> void:
	createPlayers()


func _process(delta: float) -> void:
	pass
