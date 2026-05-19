extends Node

@export var number_of_players : int = 2

@onready var player_scene = load("res://Player.tscn")


func createPlayers() -> void:
	for i in range(number_of_players):
		var player_instance = player_scene.instantiate()
		player_instance.player_id = i + 1
		player_instance.died.connect(player_death)
		add_child(player_instance)
	

func player_death(player: RigidBody2D) -> void: 
	player_respawn(player)
	
func player_respawn(player: RigidBody2D) -> void:
	await get_tree().create_timer(2.0).timeout

	player.health.setMaxHealth()

	player.linear_velocity = Vector2.ZERO
	player.angular_velocity = 0.0
	player.rotation = 0.0
	player.sleeping = false

	player.jumpTime = 0
	player.turningTime = 0
	player.unbalanacedTime = 0
	player.inContact = false
	player.isTurning = false
	player.lock_rotation = false

	player.show()
	player.get_node("Hitbox").disabled = false
	player.add_to_group("camera_objects")
	player.add_to_group("targetable")
	player.position = Vector2(365, 486)
	
func _ready() -> void:
	createPlayers()


func _process(delta: float) -> void:
	pass
