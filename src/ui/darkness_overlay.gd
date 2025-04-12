class_name DarknessOverlay extends ColorRect

@export var lightFalloff: float = 2.0
@onready var shaderMaterial: ShaderMaterial = material

var _lightSources: Array[LightSource]
var _camera: Camera2D

func _init() -> void:
	_lightSources = []
	LightEventBus.subscribe(addLightSource, updateLightSource)

func _ready() -> void:
	shaderMaterial.set_shader_parameter("viewport_size", get_viewport_rect().size)
	_camera = get_viewport().get_camera_2d()
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		LightEventBus.unsubscribe(addLightSource, updateLightSource)
		print_debug("Darkness unsubscribed from light event bus")
	
func addLightSource(source: LightSource) -> void:
	for ls in _lightSources:
		if source.uid == ls.uid:
			print_debug("Light source with UID " + str(source.uid) + " already exists.  Not adding.")
			return
			
	print_debug("light added")
	_lightSources.append(source)
	
func updateLightSource(source: LightSource) -> void:
	for ls in _lightSources:
		if source.uid == ls.uid:
			ls.position = source.position
			ls.radius = source.radius
	
func _process(_delta: float) -> void:
	var lights = PackedVector3Array()
	var camTransform = _camera.get_transform()
	
	for source: LightSource in _lightSources:
		var worldPosition: Vector2 = source.position
		var relativePos: Vector2 = worldPosition - camTransform.origin
		var screenPos: Vector2 = relativePos
		var viewRect: Rect2 = get_viewport_rect()
		screenPos.x += viewRect.size.x / 2;
		screenPos.y += viewRect.size.y / 2;
		var light: Vector3 = Vector3(screenPos.x, screenPos.y, source.radius)
		lights.append(light)
		
	shaderMaterial.set_shader_parameter("lights", lights)
	shaderMaterial.set_shader_parameter("light_count", lights.size())
	shaderMaterial.set_shader_parameter("light_falloff", lightFalloff)
 		
