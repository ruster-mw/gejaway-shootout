class_name AidKit
extends BaseWeapon


@export var bulletScene: PackedScene
@export var healing : float 
@export var shotData : Dictionary = {
	"distance" : null,
	"startPoint" : null,
	"endPoint" : null 
}
@onready var muzzlePoint = $MuzzlePoint

# an empty comment

func fire() -> Dictionary:
	var healthSystem = get_parent().get_parent().get_node("HealthSystem")
	healthSystem.heal(healing)
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
	var duration = 0.5
	while elapsed < duration:
		elapsed += get_process_delta_time()
		instance.modulate.a = lerpf(1.0, 0.0, elapsed / duration)
		await get_tree().process_frame
	instance.queue_free()

func _ready() -> void:
	pass
	

	
	
