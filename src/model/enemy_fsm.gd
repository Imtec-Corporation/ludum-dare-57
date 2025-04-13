# Enemy Finite State Machine
class_name EnemyFSM

var _stateMap: Dictionary[EnemyState.State, Array]
var _state: EnemyState.State

func _init() -> void:
	_stateMap = {}
	_state = EnemyState.State.IDLE
	
func add_transition(state: EnemyState.State, transition: EnemyStateTransition) -> void:
	if not _stateMap.has(state):
		_stateMap[state] = []
	_stateMap[state].append(transition)
	
func tick() -> void:
	for transition: EnemyStateTransition in _stateMap[_state]:
		if transition.predicate.call():
			_state = transition.nextState
			return
	
func get_state() -> EnemyState.State:
	return _state
	
