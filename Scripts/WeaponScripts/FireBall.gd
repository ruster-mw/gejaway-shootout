class_name FireBall
extends Area2D

var damage : float 
var knockback : float 
var holder : Node2D 
var travelDirection : Vector2
var speed : float
var radius
var time = 0
var started = false
var startPosition : Vector2 
var waveAmplitude = 70.0
var waveFrequency = 10.0

const explosionEffect = preload("res://Bullets/EruptionEffect.tscn")


func _draw():
	draw_arc(Vector2.ZERO, radius, 0.0, TAU, 128, Color.WHITE, 4.0, true)

func explode(directHit = null) -> void:
	var effect = explosionEffect.instantiate()
	effect.global_position = global_position
	get_tree().current_scene.add_child(effect)
	
	if directHit and directHit is RigidBody2D:
		var dir = (directHit.global_position - global_position)
		dir = travelDirection if dir.length_squared() < 0.001 else dir.normalized()
		directHit.linear_velocity += dir * knockback / directHit.mass
	if directHit and directHit.has_node("HealthSystem"):
		directHit.get_node("HealthSystem").takeDamage(damage, holder)
	var spaceState = get_world_2d().direct_space_state
	var shape = CircleShape2D.new()
	shape.radius = radius
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = shape
	query.transform = Transform2D(0, global_position)
	var hits = spaceState.intersect_shape(query)
	for hit in hits:
		var body = hit.collider
		if body == holder || body == directHit:
			continue
		var dist = global_position.distance_to(body.global_position)
		var finaldamage = -absf(0.4 * dist) + damage
		if body is RigidBody2D:
			var dir = (body.global_position - global_position).normalized()
			body.linear_velocity += dir * knockback / body.mass
		if body.has_node("HealthSystem"):
			body.get_node("HealthSystem").takeDamage(finaldamage , holder)
	queue_free()

func _process(delta: float) -> void:
	#queue_redraw()
	time += delta
	var perp = Vector2(-travelDirection.y, travelDirection.x)
	global_position = startPosition + travelDirection * speed * time + perp * waveAmplitude * cos(time * waveFrequency)+ Vector2(0, -20 * time)
	#position += travelDirection * speed * delta
	
func _ready() -> void:
	body_entered.connect(_onBodyEntered)
	get_tree().create_timer(5.0).timeout.connect(explode)

func _onBodyEntered(body) -> void:
	if body == holder:
		return
	explode(body)

func init(weapon, direction) -> void:
	damage = weapon.bulletDamage
	knockback = weapon.bulletKnockback
	holder = weapon.holder
	speed = weapon.bulletSpeed
	radius = weapon.explosionRadius
	travelDirection = direction
	startPosition = global_position
	
