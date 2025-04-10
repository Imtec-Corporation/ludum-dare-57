extends GutTest

var controller: PlayerController

func before_each():
	controller = PlayerController.new()
	
func after_each():
	controller.queue_free()
	
#func test_player_model_should_be_created():
#	assert_not_null(controller._model)
#	
#func test_player_should_increase_vertical_velocity_according_to_gravity():
#	controller.gravity = 980.0
#	controller._physics_process(2)
#	assert_eq(controller._velocity.y, 1960.0, "Should increase vertical speed by gravity/delta factor")
