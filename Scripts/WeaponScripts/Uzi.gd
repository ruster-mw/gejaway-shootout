class_name Uzi
extends BaseWeapon


@export var bulletScene: PackedScene
@export var bulletSpeed : float  
@export var bulletSpread : float 
@export var bulletDamage : float 
@export var knockback : float
@export var bulletRange : float 
@export var falloff : float
@export var shotData : Dictionary = {
	"distance" : null,
	"startPoint" : null,
	"endPoint" : null 
}
@onready var muzzlePoint = $MuzzlePoint

# an empty comment

func fire() -> Dictionary:
	var space_state = get_world_2d().direct_space_state
	var origin = muzzlePoint.global_position
	var spreadAngle = deg_to_rad(randf_range(-bulletSpread, bulletSpread))
	var direction = Vector2.DOWN.rotated(global_rotation + spreadAngle) 
	var end = origin + direction * bulletRange
	var query = PhysicsRayQueryParameters2D.create(origin, end)
	query.collision_mask = 0b00000101  # hits layers 1 and 3
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	var hitPoint = result.get("position", end)
	
	shotData.distance = origin.distance_to(hitPoint)
	shotData.startPoint = origin
	shotData.endPoint = hitPoint
	createLine(shotData)
	
	if result:
		if result.collider == holder:
			return {}
		var rangePercent = floor((result.position.distance_to(origin) / bulletRange) * 100)
		if result.collider.has_node("HealthSystem"):
			var health = result.collider.get_node("HealthSystem")
			var finalDamage = max(0, bulletDamage - (rangePercent * falloff))
			health.takeDamage(finalDamage)
		if result.collider is RigidBody2D:	
			result.collider.apply_impulse(direction * knockback, result.collider.to_local(result.position))
		return shotData
		#Add more later
	#var bullet = bulletScene.instantiate()
	#get_tree().current_scene.add_child(bullet)
	return {}

func createLine(shotData : Dictionary) -> void:
	var weaponLine = load("res://WeaponLine.tscn")
	var instance = weaponLine.instantiate()
	var gradient = Gradient.new()
	gradient.colors = [
		Color(0.4, 0.4, 0.4, 1.0),
		Color(0.525, 0.525, 0.525, 1.0)
	]
	gradient.offsets = [0.0, 1.0]
	instance.gradient = gradient
	instance.add_point(shotData.startPoint)   
	instance.add_point(shotData.endPoint) 
	get_tree().current_scene.add_child(instance)
	deleteLine(instance)

func deleteLine(instance) -> void:
	var elapsed = 0.0
	var duration = 0.3
	while elapsed < duration:
		elapsed += get_process_delta_time()
		instance.modulate.a = lerpf(1.0, 0.0, elapsed / duration)
		await get_tree().process_frame
	instance.queue_free()

func _ready() -> void:
	pass
	

	
	
