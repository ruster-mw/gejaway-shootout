class_name AimSystem
extends RigidBody2D

@export var aimRange : float = 2200
@export var shouldAim : bool = true
@onready var rigidBody : RigidBody2D = get_parent()

func getTarget() -> Node2D:
	var targets = get_tree().get_nodes_in_group("targetable")
	var closestTarget : Node2D = null
	var closestRange = INF
	for target in targets:
		if target == rigidBody: 
			continue
		var rangeToTarget = global_position.distance_to(target.global_position)
		if rangeToTarget > aimRange:
			continue
		if closestRange > rangeToTarget:
			closestRange = rangeToTarget
			closestTarget = target
	return closestTarget
	
func _draw():
	var target = getTarget()
	if target == null:
		return
	var localTarget = to_local(target.get_node("TargetPoint").global_position)
	draw_line(Vector2.ZERO, localTarget, Color.RED, 2.0)

func _physics_process(delta):
	queue_redraw()
	if (!shouldAim):
		return
	for child in get_children():
		if child is BaseWeapon:
			var muzzlePoint = child.get_node("MuzzlePoint")
			var target = getTarget()
			if target == null:
				return
			var direction = target.get_node("TargetPoint").global_position - global_position
			var target_angle = direction.angle() - PI / 2.0
			var angleDifference = wrapf(target_angle - global_rotation, -PI, PI)
			var torque_strength = 10000.0
			var damping = 500
			apply_torque(angleDifference * torque_strength - angular_velocity * damping)
	
func _ready() -> void:
	add_collision_exception_with(rigidBody)
