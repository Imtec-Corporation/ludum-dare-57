class_name PlayerController extends CharacterBody2D

@export var gravity: float = 980.0
@export var speed: float = 300.0
@export var staticFriction: float = 20.0
@export var maxFallSpeed: float = 5000.0
@export var maxSpeed: float = 2000.0
@export var jumpForce: float = 15000.0
@export var lightRadius: float = 20.0

@onready var _animator: AnimationPlayer = $gfx/AnimationPlayer
@onready var _sprite: Sprite2D = $gfx

var _model: Player
var _velocity: Vector2
var _jumpStarted: bool
var _lightSource: LightSource

var _uid: String = UIDGenerator.generate()

func _init() -> void:
	_model = Player.new()
	_velocity = Vector2.ZERO
	_jumpStarted = false

func _ready() -> void:
	_lightSource = LightSource.new(global_position, lightRadius, _uid)
	LightEventBus.lightCreated(_lightSource)	
	
func _process(_delta: float) -> void:
	_model.process_input()
	
	_sprite.flip_h = _model.get_direction() == Direction.Values.LEFT
	
	# Update light source position
	_lightSource.position = global_position
	LightEventBus.lightUpdated(_lightSource)
	
	# Set animations
	match _model.get_state():
		PlayerState.State.IDLE:
			play_animation("idle")
		PlayerState.State.WALKING:
			play_animation("walking")
		PlayerState.State.ATTACKING:
			play_animation("attack")
	
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
	
func play_animation(animation: String) -> void:
	if animation != _animator.current_animation:
		_animator.play(animation)
		
func end_attack() -> void:
	print_debug("Finishing attack")
	_model.change_state(PlayerState.State.IDLE)
