class_name EnemyController extends CharacterBody2D

@export var lightRadius: float = 100.0

var _lightSource: LightSource
var _uid: String

func _ready() -> void:
	_lightSource = LightSource.new(position, lightRadius, _uid)
	LightEventBus.lightCreated(_lightSource)
	
func _process(_delta: float) -> void:
	_lightSource.position = position
	LightEventBus.lightUpdated(_lightSource)
