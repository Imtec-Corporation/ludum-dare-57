class_name Enemy

var _health: int
var _attackDamage: int
var _fsm: EnemyFSM
var _attacks: bool
var _direction: Direction.Values
var _isActive

# Transition flags
var targetInRange: bool = false
var leftFall: bool = false
var rightFall: bool = false
var leftWall: bool = false
var rightWall: bool = false
var leftTier: bool = false
var rightTier: bool = false
var landed: bool = false
var beingDamaged: bool = false
var attackFinished: bool = false

func _init(health: int, attackDamage: int, attacks: bool) -> void:
	_health = health
	_attackDamage = attackDamage
	_fsm = EnemyFSM.new()
	_attacks = attacks
	_direction = Direction.Values.RIGHT
	_isActive = false
	
	_setup_states()
	
func activate() -> void:
	_isActive = true
	
func deactivate() -> void:
	_isActive = false
	
func _is_active() -> bool:
	return _isActive
	
func _target_in_range() -> bool:
	return targetInRange and _attacks
	
func _should_jump_left() -> bool:
	return leftTier
	
func _should_jump_right() -> bool:
	return rightTier
	
func _is_landed() -> bool:
	return landed
	
func _is_being_damaged() -> bool:
	return beingDamaged
	
func _damage_ended() -> bool:
	return !beingDamaged
	
func _empty_health() -> bool:
	return _health <= 0 and not beingDamaged
	
func _attack_finished() -> bool:
	return attackFinished
	
func _setup_states() -> void:
	# Define transitions to patrol
	var patrolTransition = EnemyStateTransition.new(EnemyState.State.PATROL, self._is_active)
	var landTransition = EnemyStateTransition.new(EnemyState.State.PATROL, self._is_landed)
		
	# Define transitions to attack
	var attackTransition = EnemyStateTransition.new(EnemyState.State.ATTACK, self._target_in_range)
	
	# Define transitions to jump
	var leftJumpTransition = EnemyStateTransition.new(EnemyState.State.JUMP, self._should_jump_left)
	var rightJumpTransition = EnemyStateTransition.new(EnemyState.State.JUMP, self._should_jump_right)
	
	# Define transitions to damaged
	var damageTransition = EnemyStateTransition.new(EnemyState.State.DAMAGED, self._is_being_damaged)
	
	# Define transitions to dead
	var deadTransition = EnemyStateTransition.new(EnemyState.State.DEAD, self._empty_health)
	
	# Define transitions to idle
	var damageEndTransition = EnemyStateTransition.new(EnemyState.State.IDLE, self._damage_ended)
	var attackEndTransition = EnemyStateTransition.new(EnemyState.State.IDLE, self._attack_finished)
		
	# Set transitions from idle
	_fsm.add_transition(EnemyState.State.IDLE, damageTransition)
	_fsm.add_transition(EnemyState.State.IDLE, patrolTransition)
	
	# Set transitions from patrol
	_fsm.add_transition(EnemyState.State.PATROL, damageTransition)
	_fsm.add_transition(EnemyState.State.PATROL, attackTransition)
	_fsm.add_transition(EnemyState.State.PATROL, leftJumpTransition)
	_fsm.add_transition(EnemyState.State.PATROL, rightJumpTransition)
	
	# Set transitions from jump
	_fsm.add_transition(EnemyState.State.JUMP, damageTransition)
	_fsm.add_transition(EnemyState.State.JUMP, attackTransition)
	_fsm.add_transition(EnemyState.State.JUMP, landTransition)
	
	# Set transitions from damaged
	_fsm.add_transition(EnemyState.State.DAMAGED, deadTransition)
	_fsm.add_transition(EnemyState.State.DAMAGED, damageEndTransition)
	
	# Set transitions from attack
	_fsm.add_transition(EnemyState.State.ATTACK, attackEndTransition)
	
func update() -> void:
	_fsm.tick()
	match get_state():
		EnemyState.State.PATROL:
			if ((_direction == Direction.Values.RIGHT and rightWall) or
				(_direction == Direction.Values.LEFT and leftWall) or
				(_direction == Direction.Values.RIGHT and rightFall) or
				(_direction == Direction.Values.LEFT and leftFall)):
				change_direction()
	
func change_direction() -> void:
	if _direction == Direction.Values.RIGHT:
		_direction = Direction.Values.LEFT
	else:
		_direction = Direction.Values.RIGHT
	
func get_health() -> int:
	return _health
	
func get_state() -> EnemyState.State:
	return _fsm.get_state()
	
func get_direction() -> Direction.Values:
	return _direction
	
func take_damage(amount: int) -> void:
	_health -= amount
	if _health < 0:
		_health = 0
	beingDamaged = true
