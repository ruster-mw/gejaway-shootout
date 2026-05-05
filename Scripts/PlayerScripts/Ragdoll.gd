extends RigidBody2D

@export var turnRight : bool = true

@onready var sprite : Sprite2D  = $Body
@onready var armSprite : Sprite2D = $Arm/ArmSprite

func _handleVisuals() -> void:
	sprite.flip_h = !turnRight
	armSprite.flip_h = !turnRight

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	_handleVisuals()
