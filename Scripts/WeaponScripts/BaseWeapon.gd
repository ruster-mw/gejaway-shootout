class_name BaseWeapon
extends Node2D

signal pickedUp(weapon)
signal used
signal exhausted  

@export var ammo : int = 1
@export var weaponName : String = ""
@export var cooldown : float = 0
@export var maxCooldown : float = 0
@export var automatic : bool = false

var holder: RigidBody2D
var isHeld: bool = false

func pickUp(player: RigidBody2D) -> void:
	holder = player
	isHeld = true
	pickedUp.emit(self)
	onPickedUp()

func use() -> void:
	if ammo <= 0 || cooldown > 0:
		return
	cooldown = maxCooldown
	ammo -= 1
	used.emit()
	fire()
	if ammo <= 0:
		exhausted.emit()
		print("out of ammo")
		deleteGun()

func onPickedUp() -> void:
	pass

func fire() -> Dictionary:
	return {}

func deleteGun(time : float = 1.25) -> void:
	await get_tree().create_timer(time).timeout
	queue_free()

func _process(delta: float) -> void:
	if cooldown > 0:
		cooldown -= delta
	var pressed = Input.is_action_pressed("player1_powerup") if automatic else Input.is_action_just_pressed("player1_powerup")
	if pressed:
		use()
	
