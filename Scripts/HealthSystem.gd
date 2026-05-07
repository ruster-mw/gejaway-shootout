class_name HealthSystem
extends Node

signal died
signal health_changed(old_value, new_value)
signal damaged(amount)
signal healed(amount)

@export var maxHealth : float = 100.0
var currentHealth : float
var isInvincible : bool = false #Are you sure?

func _ready():
	currentHealth = maxHealth

func takeDamage(amount: float):
	if currentHealth <= 0 or isInvincible:
		return 
	var old = currentHealth
	currentHealth = max(0, currentHealth - amount)
	emit_signal("health_changed", old, currentHealth)
	emit_signal("damaged", amount)

	if currentHealth == 0:
		emit_signal("died")

func heal(amount: float):
	if currentHealth <= 0:
		return  
	var old = currentHealth
	currentHealth = min(maxHealth, currentHealth + amount)
	emit_signal("health_changed", old, currentHealth)
	emit_signal("healed", amount)

func setMaxHealth() -> void:
	currentHealth = maxHealth
	
func setInvincible(invincibility : bool, duration = null) -> void:
	isInvincible = invincibility
	
	
func isDead() -> bool:
	return currentHealth <= 0
