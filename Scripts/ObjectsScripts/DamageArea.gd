extends Area2D

@export var damage: float = 10.0
@export var damage_interval: float = 0.5 

var bodies_inside: Array = []

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	var timer = Timer.new()
	timer.wait_time = damage_interval
	timer.timeout.connect(_on_tick)
	add_child(timer)
	timer.start()

func _on_body_entered(body):
	if body.has_node("HealthSystem"):
		bodies_inside.append(body)

func _on_body_exited(body):
	bodies_inside.erase(body)

func _on_tick():
	for body in bodies_inside:
		body.get_node("HealthSystem").takeDamage(damage)
