extends Node

@export var number_of_players : int = 2

@onready var player_scene = load("res://Player.tscn")


func createPlayers() -> void:
	for i in range(number_of_players):
		var player_instance = player_scene.instantiate()
		player_instance.player_id = i + 1
		player_instance.died.connect(player_death)
		add_child(player_instance)
		print(player_instance.position)
	

func player_death(player: RigidBody2D) -> void: 
	player_respawn(player)
	
func player_respawn(player: RigidBody2D) -> void:
	await get_tree().create_timer(5.0).timeout
	print("dziala")
	player.show()
	player.get_node("Hitbox").disabled = false
	player.position = Vector2(229, 300)
	
func _ready() -> void:
	createPlayers()


func _process(delta: float) -> void:
	pass
