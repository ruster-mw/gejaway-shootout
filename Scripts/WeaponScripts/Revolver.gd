class_name Revolver
extends BaseWeapon

@export var bulletScene : PackedScene = load("res://Bullets/RevolverBullet.tscn")
@export var bulletSpeed : float = 3000.0
@export var bulletDamage : float = 31.0
@export var bulletKnockback : float = 400.0

@onready var muzzlePoint : Marker2D = $MuzzlePoint

func fire() -> Dictionary:
	var bullet : RevolverBullet = bulletScene.instantiate()
	bullet.global_position = muzzlePoint.global_position
	bullet.global_rotation = muzzlePoint.global_rotation
	var direction = Vector2.DOWN.rotated(muzzlePoint.global_rotation)
	get_tree().current_scene.add_child(bullet)
	bullet.init(self)
	bullet.linear_velocity = direction * bulletSpeed
	return {}


	
	
