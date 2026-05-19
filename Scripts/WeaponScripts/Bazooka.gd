class_name Bazooka
extends BaseWeapon

@export var bulletScene : PackedScene = load("res://Bullets/BazookaBullet.tscn")
@export var bulletSpeed : float 
@export var bulletDamage : float 
@export var bulletKnockback : float 

@onready var muzzlePoint : Marker2D = $MuzzlePoint

func fire() -> Dictionary:
	var bullet = bulletScene.instantiate()
	bullet.global_position = muzzlePoint.global_position
	bullet.global_rotation = muzzlePoint.global_rotation
	var direction = Vector2.DOWN.rotated(muzzlePoint.global_rotation)
	get_tree().current_scene.add_child(bullet)
	bullet.init(self)
	bullet.linear_velocity = direction * bulletSpeed
	return {}


	
	
