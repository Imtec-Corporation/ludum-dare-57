class_name EnemyController extends CharacterBody2D

@export var lightRadius: float = 100.0
@export var damage: int = 1
@export var health: int = 1
@export var attacks: bool = false
@export var speed: float = 30
@export var gravity: float = 980
@export var jumpForce: float = 20000

var _lightSource: LightSource
var _uid: String
var _model: Enemy
var _sprite: Sprite2D
var _velocity: Vector2
var _jumpStarted:  bool

func _init() -> void:
	_model = Enemy.new(health, damage, attacks)
	_velocity = Vector2.ZERO
	_jumpStarted = false
	
func _ready() -> void:
	_sprite = $gfx
	_lightSource = LightSource.new(position, lightRadius, _uid)
	LightEventBus.lightCreated(_lightSource)
	_model.activate()
	
func _process(_delta: float) -> void:
	_model.update()
	
	_sprite.flip_h = _model.get_direction() == Direction.Values.LEFT
	
	_lightSource.position = position
	LightEventBus.lightUpdated(_lightSource)
	
func _physics_process(delta: float) -> void:
	_velocity = velocity
	if not is_on_floor():
		_velocity.y += gravity * delta
		
	if is_on_floor() and _model.get_state() == EnemyState.State.JUMP:
		if not _jumpStarted:
			_velocity.y = -jumpForce * delta
			_jumpStarted = true
			_model.landed = false
		else :
			_model.landed = true
			_jumpStarted = false
	
	if [EnemyState.State.PATROL, EnemyState.State.JUMP].has(_model.get_state()):
		if _model.get_direction() == Direction.Values.RIGHT:
			_velocity.x = speed
		else:
			_velocity.x = -speed
			
		velocity = velocity.lerp(_velocity, 100 * delta)
		move_and_slide()
		
func _on_right_wall_detected(wall: Node2D) -> void:
	_model.rightWall = _model.get_direction() == Direction.Values.RIGHT
	
func _on_left_wall_detected(wall: Node2D) -> void:
	_model.leftWall = _model.get_direction() == Direction.Values.LEFT
	
func _on_right_wall_undetected(wall: Node2D) -> void:
	_model.rightWall = false
	
func _on_left_wall_undetected(wall: Node2D) -> void:
	_model.leftWall = false
	
func _on_right_fall_detected(fall: Node2D) -> void:
	_model.rightFall = _model.get_direction() == Direction.Values.RIGHT
	
func _on_left_fall_detected(fall: Node2D) -> void:
	_model.leftFall = _model.get_direction() == Direction.Values.LEFT
	
func _on_right_fall_undetected(fall: Node2D) -> void:
	_model.rightFall = false
	
func _on_left_fall_undetected(fall: Node2D) -> void:
	_model.leftFall = false
	
func _on_right_tier_detected(tier: Node2D) -> void:
	_model.rightTier = true
	
func _on_left_tier_detected(tier: Node2D) -> void:
	_model.leftTier = true
	
func _on_right_tier_undetected(tier: Node2D) ->void:
	_model.rightTier = false
	
func _on_left_tier_undetected(tier: Node2D) -> void:
	_model.leftTier = false
