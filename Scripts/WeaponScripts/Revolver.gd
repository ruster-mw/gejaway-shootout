class_name Revolver
extends BaseWeapon

@export var bulletScene: PackedScene
@export var bulletSpeed : float  = 1200.0
@export var bulletSpread : float = 0.05
@export var bulletDamage : float = 30
@export var knockback : float = 200
@export var bulletRange : float = 2500

@onready var muzzlePoint = $MuzzlePoint
@onready var ray_line = $Line2D

func fire() -> void:
	var space_state = get_world_2d().direct_space_state
	var origin = muzzlePoint.global_position
	var direction = Vector2.RIGHT.rotated(global_rotation)  
	var end = origin + direction * bulletRange
	var query = PhysicsRayQueryParameters2D.create(origin, end)
	query.collision_mask = 0b00000101  # hits layers 1 and 3
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	if result:
		print("ray shot")
		print("found a result")
		if result.collider.has_node("HealthSystem"):
			var health = result.collider.get_node("HealthSystem")
			health.takeDamage(bulletDamage)
		if result.collider is RigidBody2D:	
			print("applied knockback")
			result.collider.apply_impulse(direction * knockback, result.collider.to_local(result.position))
		#Add more later
	#var bullet = bulletScene.instantiate()
	#get_tree().current_scene.add_child(bullet)
	
func _ready() -> void:
	weapon_name = "Revolver"
	ammo = 6
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("player1_powerup"):
		print("shot")
		fire()
