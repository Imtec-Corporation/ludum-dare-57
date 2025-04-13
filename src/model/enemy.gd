class_name Enemy

var _health: int
var _fsm: EnemyFSM

func _init(health: int, fsm: EnemyFSM) -> void:
	_health = health
	
