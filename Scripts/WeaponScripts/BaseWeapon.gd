class_name BaseWeapon
extends Node2D

signal pickedUp(weapon)
signal used
signal exhausted  

@export var ammo : int = 1
@export var weaponName : String = ""
@export var maxCooldown : float = 0
@export var automatic : bool = false
@export var pressed : bool = false
@export var aim : bool = true
@export var flipx = false
var cooldown : float = 0

@onready var gripPoint: Marker2D = $GripPoint

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
	print(ammo)
	used.emit()
	fire()
	if ammo <= 0:
		exhausted.emit()
		deleteGun()

func onPickedUp() -> void:
	pass

func fire() -> Dictionary:
	return {}

func deleteGun(time : float = 0.5) -> void:
	await get_tree().create_timer(time).timeout
	queue_free()

func _process(delta: float) -> void:
	if cooldown > 0:
		cooldown -= delta
	
	
