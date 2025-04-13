# Enemy Finite State Machine
class_name EnemyFSM

var _stateMap: Dictionary[EnemyState.State, EnemyStateTransition]
var _state: EnemyState.State

func _init() -> void:
	_stateMap = {}
	_state = EnemyState.State.IDLE
	
func add_transition(state: EnemyState.State, transition: EnemyStateTransition) -> void:
	_stateMap[state] = transition
	
func tick() -> void:
	var transition: EnemyStateTransition = _stateMap[_state]
	if transition.predicate.call():
		_state = transition.nextState
	
func get_state() -> EnemyState.State:
	return _state
	
