class_name BazookaBullet
extends Area2D

var damage : float 
var knockback : float 
var holder : Node2D 
var travelDirection : Vector2
var speed : float

func _process(delta: float) -> void:
	position += travelDirection * speed * delta

func _ready() -> void:
	body_entered.connect(_onBodyEntered)
	get_tree().create_timer(3.0).timeout.connect(queue_free)

func _onBodyEntered(body) -> void:
	if body == holder:
		return
	if body.has_node("HealthSystem"):
		body.get_node("HealthSystem").takeDamage(damage, holder)
	if body is RigidBody2D:
		body.apply_central_impulse(travelDirection * knockback)
	queue_free()

func init(weapon, direction) -> void:
	damage = weapon.bulletDamage
	knockback = weapon.bulletKnockback
	holder = weapon.holder
	speed = weapon.bulletSpeed
	travelDirection = direction
