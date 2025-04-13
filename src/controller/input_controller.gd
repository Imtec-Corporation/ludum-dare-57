class_name InputController

var _canAttack: bool

func _init() -> void:
	_canAttack = true

func is_left_pressed() -> bool: 
	return Input.is_action_pressed("left")
	
func is_right_pressed() -> bool:
	return Input.is_action_pressed("right")
	
func is_jump_pressed() -> bool:
	return Input.is_action_pressed("jump")
	
func is_attack_pressed() -> bool:
	if Input.is_action_pressed("attack") and _canAttack:
		_canAttack = false
		return true
	elif not Input.is_action_pressed("attack") and not _canAttack:
		_canAttack = true
	return false
	
func is_interact_pressed() -> bool:
	return Input.is_action_pressed("interact")
	
func is_illuminate_pressed() -> bool:
	return Input.is_action_pressed("illuminate")
