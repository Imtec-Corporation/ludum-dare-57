class_name ScrollCamController extends Camera2D

@export var target = Node2D

func _process(delta: float) -> void:
	position = position.slerp(target.position, 100 * delta)
