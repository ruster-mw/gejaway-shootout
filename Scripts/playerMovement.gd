extends RigidBody2D

@export var velocityX := 500.0
@export var velocityY := 300.0

@onready var sprite : Sprite2D  = $Body
@onready var floorRayCast : RayCast2D = $FloorRayCast
@onready var leftFloorRayCast : RayCast2D = $LeftFloorRayCast
@onready var rightFloorRayCast : RayCast2D = $RightFloorRayCast

var facingRight : bool = true
var getrotation : float = 0.0
var maxUpRightAngle : float = 7.2
var maxTurnAngle : float = 53.5
var balancePower : float = 2000.0
var turnSpeed : float = 280

var inContact : bool = false
var isTurning : bool
var turnRight : bool
var hasAppliedDamp : bool

func _balance() -> void:
	getrotation = rotation_degrees
	getrotation = wrapf(getrotation, -180.0, 180.0)
	if (absf(getrotation) > maxUpRightAngle):
		if (inContact):
			var directionPower = -getrotation
			apply_torque(directionPower * balancePower)
			#hasAppliedDamp = false
	else:
		if hasAppliedDamp == false:
			angular_velocity = angular_velocity / 100.0
			hasAppliedDamp = true



func _handleVisuals() -> void:
	sprite.flip_h = not facingRight

#func _handleInput() -> void:
	#if Input.is_action_just_pressed('move_left'):
		#_jump(-velocityX)
	#elif Input.is_action_just_pressed('move_right'):	
		#_jump(velocityX)
#
#func _jump(horizontal: float) -> void:
	#facingRight = horizontal > 0

func _startTurn(turningRight : bool) -> void:
	if (isTurning || isGrounded() == false):
		return;
	lock_rotation = true
	turnRight = turningRight
	isTurning = true

func _turn(delta : float) -> void:
	getrotation = rotation_degrees
	getrotation = wrapf(getrotation, -180.0, 180.0)
	var direction = 1 if turnRight else -1
	
	if ((getrotation > maxTurnAngle * direction) == !turnRight):
		print(getrotation + turnSpeed * direction * delta)
		rotation_degrees = getrotation + turnSpeed * direction * delta
		
	
func isGrounded() -> bool:
	return floorRayCast.is_colliding() || rightFloorRayCast.is_colliding() || leftFloorRayCast.is_colliding()







func _ready() -> void:	
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_left"):
		_startTurn(false)
	elif Input.is_action_just_pressed("move_right"):
		_startTurn(true)

func _physics_process(delta: float) -> void:
	inContact = get_contact_count() > 0
	if (isTurning):
		_turn(delta)
	else: 
		_balance()
	#_handleInput()
	_handleVisuals()
