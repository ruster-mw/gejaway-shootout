extends Area2D

@export var weaponPool : Array[WeaponData] = []

@onready var sprite : Sprite2D = $Sprite2D

var rolledWeapon : WeaponData


func rollWeapon() -> void:
	print("pool size: ", weaponPool.size())
	for i in weaponPool.size():
		print(i, ": ", weaponPool[i])

	if not rolledWeapon:
		rolledWeapon = weaponPool.pick_random()
		sprite.texture = rolledWeapon.weaponSprite

func _ready() -> void:
	print("running node: ", get_path())
	print("pool size: ", weaponPool.size())
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
		return
	print("no player found")
	
