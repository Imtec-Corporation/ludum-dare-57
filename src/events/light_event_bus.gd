class_name LightEventBus

class Signals:
	signal lightCreated(lightSource: LightSource)
	signal lightUpdated(lightSource: LightSource)
	
static var signals = Signals.new()

static func subscribe(created: Callable, updated: Callable) -> void:
	signals.lightCreated.connect(created)
	signals.lightUpdated.connect(updated)

static func unsubscribe(created: Callable, updated: Callable) -> void:
	signals.lightCreated.disconnect(created)
	signals.lightUpdated.disconnect(updated)
	
static func lightCreated(lightSource: LightSource) -> void:
	signals.lightCreated.emit(lightSource)
	
static func lightUpdated(lightSource: LightSource) -> void:
	signals.lightUpdated.emit(lightSource)
