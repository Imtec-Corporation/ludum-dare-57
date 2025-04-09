extends GutTest

var controller: InputController
var mock: GutInputSender

func before_all():
	controller = InputController.new()
	mock = GutInputSender.new(Input)
	
func after_each():
	mock.release_all()
	mock.clear()

func test_all_buttons_should_be_released():
	assert_false(controller.is_left_pressed())
	assert_false(controller.is_right_pressed())
	assert_false(controller.is_jump_pressed())
	assert_false(controller.is_attack_pressed())
	assert_false(controller.is_interact_pressed())

func test_press_left():
	mock.action_down("left")
	assert_true(controller.is_left_pressed())
	mock.action_up("left")
	assert_false(controller.is_left_pressed())
	
func test_press_right():
	mock.action_down("right")
	assert_true(controller.is_right_pressed())
	mock.action_up("right")
	assert_false(controller.is_right_pressed())
	
func test_press_jump():
	mock.action_down("jump")
	assert_true(controller.is_jump_pressed())
	mock.action_up("jump")
	assert_false(controller.is_jump_pressed())
	
func test_press_attack():
	mock.action_down("attack")
	assert_true(controller.is_attack_pressed())
	mock.action_up("attack")
	assert_false(controller.is_attack_pressed())
	
func test_press_interact():
	mock.action_down("interact")
	assert_true(controller.is_interact_pressed())
	mock.action_up("interact")
	assert_false(controller.is_interact_pressed())
	
func test_attack_should_not_repeat_when_hold_pressed():
	mock.action_down("attack")
	assert_true(controller.is_attack_pressed())
	OS.delay_msec(200)
	assert_false(controller.is_attack_pressed(), "Attack should not be accepted when hold")
