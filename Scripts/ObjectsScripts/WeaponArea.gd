extends Area2D

@export var weaponPool : Array[WeaponData] = []

@onready var sprite : Sprite2D = $Sprite2D
@onready var sprite2 : Sprite2D = $Sprite2D2

var rolledWeapon : WeaponData


func rollWeapon() -> void:
	if not rolledWeapon:
		rolledWeapon = weaponPool.pick_random()
		sprite.texture = rolledWeapon.weaponSprite
		sprite2.visible = true

func roll() -> void:
	await get_tree().create_timer(5.5).timeout
	rollWeapon()

func _ready() -> void:
	body_entered.connect(onBodyEntered)
	rollWeapon()
	


func onBodyEntered(body : Node) -> void:
	if not rolledWeapon:
		return
	if body.is_in_group("players"):
		for child in body.find_children("*", "BaseWeapon", true, false):
			if child is BaseWeapon:
				return
		var weapon = rolledWeapon.weaponScene.instantiate()
		body.addWeapon(weapon)
		rolledWeapon = null
		sprite.texture = null
		sprite2.visible = false
		roll()
		return
	print("no player found")
	
