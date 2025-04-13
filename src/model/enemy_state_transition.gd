class_name EnemyStateTransition

var nextState: EnemyState.State
var predicate: Callable

func _init(nextState: EnemyState.State, predicate: Callable) -> void:
	self.nextState = nextState
	self.predicate = predicate
	
