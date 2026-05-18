class_name RevolverBullet
extends RigidBody2D

var damage : float 
var knockback : float 
var holder : Node2D 

func _ready() -> void:
	body_entered.connect(_onBodyEntered)
	get_tree().create_timer(3.0).timeout.connect(queue_free)

func _onBodyEntered(body: Node) -> void:
	if body == holder:
		return
	if body.has_node("HealthSystem"):
		body.get_node("HealthSystem").takeDamage(damage, holder)
	if body is RigidBody2D:
		body.apply_central_impulse(linear_velocity.normalized() * knockback)
	queue_free()

func init(weapon : Revolver) -> void:
	damage = weapon.bulletDamage
	knockback = weapon.bulletKnockback
	holder = weapon.holder
