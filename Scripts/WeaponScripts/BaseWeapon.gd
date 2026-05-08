class_name BaseWeapon
extends Node2D

signal pickedUp(weapon)
signal used
signal exhausted  

@export var ammo: int = 1
@export var weapon_name: String = ""

var holder: RigidBody2D
var is_held: bool = false

func pick_up(player: RigidBody2D) -> void:
	holder = player
	is_held = true
	pickedUp.emit(self)
	on_picked_up()

func use() -> void:
	if ammo <= 0:
		return
	ammo -= 1
	used.emit()
	fire()
	if ammo <= 0:
		exhausted.emit()

func on_picked_up() -> void:
	pass

func fire() -> void:
	pass
