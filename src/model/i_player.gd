class_name IPlayer

func process_input() -> void:
	push_error("This is an interface method")
	
func walk() -> void:
	push_error("This is an interface method")
	
func jump() -> void:
	push_error("This is an interface method")
	
func get_state() -> PlayerState.State:
	push_error("This is an interface method")
	return PlayerState.State
	
func get_direction() -> Direction.Values:
	push_error("This is an interface method")
	return Direction.Values
	
func change_state(new_state: PlayerState.State) -> void:
	push_error("This is an interface method")
	
func get_health() -> int:
	push_error("This is an interface method")
	return -100
	
func take_damage(amount: int) -> void:
	push_error("This is an interface method")
