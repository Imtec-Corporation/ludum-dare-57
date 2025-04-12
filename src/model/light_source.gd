class_name LightSource

var position: Vector2
var radius: float = 20.0
var uid: int

func _init(position, radius, uid) -> void:
	self.position = position
	self.radius = radius
	self.uid = uid
	
