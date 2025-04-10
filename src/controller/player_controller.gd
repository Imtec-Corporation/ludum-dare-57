class_name PlayerController extends CharacterBody2D

@export var gravity: float = 980.0
@export var speed: float = 300.0
@export var staticFriction: float = 20.0
@export var maxFallSpeed: float = 5000.0
@export var maxSpeed: float = 2000.0
@export var jumpForce: float = 15000.0

var _model: Player
var _velocity: Vector2
var _jumpStarted: bool

func _init() -> void:
	_model = Player.new()
	_velocity = Vector2.ZERO
	_jumpStarted = false
	
func _process(delta: float) -> void:
	_model.process_input()
	
func _physics_process(delta: float) -> void:
	_velocity = velocity
	if !is_on_floor():
		_velocity.y += gravity * delta
		
	if is_on_floor() and _model.get_state() == PlayerState.State.JUMPING:
		if ! _jumpStarted:
			_velocity.y = -jumpForce * delta
			_velocity.x *= 1.5
			_jumpStarted = true
		else:
			_model.land()
			_jumpStarted = false 
		
	if _model.get_state() == PlayerState.State.WALKING:
		if _model.get_direction() == Direction.Values.RIGHT:
			_velocity.x += speed * delta
		else:
			_velocity.x -= speed * delta
			
	if _model.get_state() != PlayerState.State.WALKING and _model.get_state() != PlayerState.State.JUMPING:
		_velocity.x = lerpf(velocity.x, 0, delta)
		
	velocity = velocity.lerp(_velocity, 100 * delta)
	move_and_slide()
