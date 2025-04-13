class_name Player extends IPlayer

var _state: PlayerState.State
var _direction: Direction.Values
var _input: InputController
var _health: int

func _init() -> void:
	_direction = Direction.Values.RIGHT
	_input = InputController.new()
	_health = 100

func get_state() -> PlayerState.State:
	return _state
	
func get_direction() -> Direction.Values:
	return _direction
	
func process_input() -> void:
	if _input.is_right_pressed():
		change_state(PlayerState.State.WALKING)
		_direction = Direction.Values.RIGHT
	elif _input.is_left_pressed():
		change_state(PlayerState.State.WALKING)
		_direction = Direction.Values.LEFT
	elif not _input.is_illuminate_pressed():
		change_state(PlayerState.State.IDLE)
		
	if _input.is_jump_pressed():
		change_state(PlayerState.State.JUMPING)
		
	if _input.is_attack_pressed():
		change_state(PlayerState.State.ATTACKING)
		
	if _input.is_interact_pressed():
		change_state(PlayerState.State.INTERACTING)
		
	if _input.is_illuminate_pressed():
		change_state(PlayerState.State.IDLE_LIGHT)
	elif _state == PlayerState.State.IDLE_LIGHT:
		change_state(PlayerState.State.IDLE)
		
func change_state(new_state: PlayerState.State) -> void:
	if ((_state == PlayerState.State.WALKING and new_state == PlayerState.State.IDLE_LIGHT) or 
	(_state == PlayerState.State.IDLE_LIGHT and new_state == PlayerState.State.WALKING)
	):
		_state = PlayerState.State.WALKING_LIGHT
		return
		
	if new_state == PlayerState.State.WALKING or new_state == PlayerState.State.JUMPING:
		if (
			_state != PlayerState.State.IDLE and 
			_state != PlayerState.State.WALKING and 
			_state != PlayerState.State.IDLE_LIGHT and 
			_state != PlayerState.State.WALKING_LIGHT):
			return
	
	if new_state == PlayerState.State.ATTACKING and (
		_state != PlayerState.State.IDLE and
		_state != PlayerState.State.WALKING and 
		_state != PlayerState.State.JUMPING
		):
			return
			
	if new_state == PlayerState.State.INTERACTING and _state != PlayerState.State.IDLE:
		return
		
	if (
		new_state == PlayerState.State.IDLE and
		_state != PlayerState.State.WALKING and 
		_state != PlayerState.State.ATTACKING and
		_state != PlayerState.State.IDLE_LIGHT):
		return
		
	_state = new_state
	
func get_health() -> int:
	return _health
	
func take_damage(amount: int) -> void:
	_health -= amount
	if _health <= 0:
		_health = 0
		change_state(PlayerState.State.DEAD)
	else:
		change_state(PlayerState.State.DAMAGED)
		
func land() -> void:
	_state = PlayerState.State.IDLE
