class_name InputController

func is_left_pressed() -> bool: 
	return Input.is_action_pressed("left")
	
func is_right_pressed() -> bool:
	return Input.is_action_pressed("right")
	
func is_jump_pressed() -> bool:
	return Input.is_action_pressed("jump")
	
func is_attack_pressed() -> bool:
	return Input.is_action_pressed("attack")
	
func is_interact_pressed() -> bool:
	return Input.is_action_pressed("interact")
