extends RigidBody2D

@export var velocityX := 500.0
@export var velocityY := 300.0
@export var player_id : int = 1

@onready var sprite : Sprite2D  = $Body
@onready var armSprite : Sprite2D = $Arm/ArmSprite
@onready var floorRayCast : RayCast2D = $FloorRayCast
@onready var leftFloorRayCast : RayCast2D = $LeftFloorRayCast
@onready var rightFloorRayCast : RayCast2D = $RightFloorRayCast
@onready var shapeCase : ShapeCast2D  = $FloorShapeCast


var facingRight : bool = true
var getrotation : float = 0.0
var maxUpRightAngle : float = 7.2
var maxTurnAngle : float = 53.5
var balancePower : float = 2000.0
var maxTurnSpeed : float = 280
var jumpPower : float = 1100.0
var lerpTurnTime : float = 0.5
var jumpCoolDown = 0.15
var jumpTime : float = 0

var turningTime : float
var unbalanacedTime : float
var inContact : bool = false
var isTurning : bool
var turnRight : bool = true
var hasAppliedDamp : bool


func _balance(delta : float) -> void:
	getrotation = rotation_degrees
	getrotation = wrapf(getrotation, -180.0, 180.0)
	if (absf(getrotation) > maxUpRightAngle):
		if (inContact):
			unbalanacedTime += delta
			var extraForceMult = clamp(ceil(unbalanacedTime / 1.2), 1, 4)
			var directionPower = clamp(-getrotation, -90.0, 90.0)
			apply_torque(directionPower * extraForceMult * balancePower)
	else:
		if unbalanacedTime > 0:
			angular_velocity = angular_velocity / 100.0
			unbalanacedTime = 0
			

func _startTurn(turningRight : bool) -> void:
	if (isTurning || isGrounded() == false || jumpTime > 0):
		return;
	lock_rotation = true
	turnRight = turningRight
	isTurning = true

func _turn(delta : float) -> void:
	turningTime += delta
	
	getrotation = rotation_degrees
	getrotation = wrapf(getrotation, -180.0, 180.0)
	var direction = 1 if turnRight else -1
	
	var turnSpeed : float = min(turningTime / lerpTurnTime, 1.0) * maxTurnSpeed
	if ((getrotation > maxTurnAngle * direction) == !turnRight):
		rotation_degrees = getrotation + turnSpeed * direction * delta
		
	
func isGrounded() -> bool:
	return floorRayCast.is_colliding() || rightFloorRayCast.is_colliding() || leftFloorRayCast.is_colliding()

func jump(jumpRight : bool) -> void:
	if (!isTurning || jumpRight != turnRight):
		return;
	if (isGrounded()):
		apply_central_impulse(Vector2.UP.rotated(rotation) * jumpPower)
	isTurning = false
	lock_rotation = false
	turningTime = 0

func _handleVisuals() -> void:
	sprite.flip_h = !turnRight
	armSprite.flip_h = !turnRight






func _ready() -> void:	
	pass

func _process(delta: float) -> void:
	var left = "player%d_move_left" % player_id
	var right = "player%d_move_right" % player_id
	if Input.is_action_pressed(left):
		_startTurn(false)
	elif Input.is_action_pressed(right):
		_startTurn(true)
		
	if Input.is_action_just_released(left):
		jump(false)
	elif Input.is_action_just_released(right):
		jump(true)

func _physics_process(delta: float) -> void:
	if (jumpTime > 0):
		jumpTime -= delta
	inContact = get_contact_count() > 0
	if (isTurning):
		_turn(delta)
	else: 
		_balance(delta)
	#inContact = false
	#_handleInput()
	_handleVisuals()
	
	
	
	#func _handleInput() -> void:
	#if Input.is_action_just_pressed('move_left'):
		#_jump(-velocityX)
	#elif Input.is_action_just_pressed('move_right'):	
		#_jump(velocityX)
#
#func _jump(horizontal: float) -> void:
	#facingRight = horizontal > 0
