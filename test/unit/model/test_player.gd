extends GutTest

var player: IPlayer
var input: GutInputSender

func before_all():
	input = GutInputSender.new(Input)

func before_each():
	player = Player.new()
	
func after_each():
	input.release_all()
	input.clear()
	
func after_all():
	input = null
	player = null
	
func test_player_should_have_full_health():
	assert_eq(player.get_health(), 100)

func test_player_input_controller_should_not_be_idle_by_default():
	assert_eq(player.get_state(), PlayerState.State.IDLE)

func test_player_default_direction_should_be_right():
	assert_eq(player.get_direction(), Direction.Values.RIGHT)
	
func test_player_press_right_should_change_state_to_walk():
	input.action_down("right")
	player.process_input()
	assert_eq(player.get_state(), PlayerState.State.WALKING)
	assert_eq(player.get_direction(), Direction.Values.RIGHT)
	input.action_up("right")
	player.process_input()
	assert_eq(player.get_state(), PlayerState.State.IDLE)
	
func test_player_press_left_should_change_state_to_walk():
	input.action_down("left")
	player.process_input()
	assert_eq(player.get_state(), PlayerState.State.WALKING)
	assert_eq(player.get_direction(), Direction.Values.LEFT)
	input.action_up("left")
	player.process_input()
	assert_eq(player.get_state(), PlayerState.State.IDLE)
	
func test_player_press_attack_should_change_state_to_attack():
	input.action_down("attack")
	player.process_input()
	assert_eq(player.get_state(), PlayerState.State.ATTACKING)
	
func test_player_press_jump_should_change_state_to_jump():
	input.action_down("jump")
	player.process_input()
	assert_eq(player.get_state(), PlayerState.State.JUMPING)
	
func test_player_press_interact_should_change_state_to_interact():
	input.action_down("interact")
	player.process_input()
	assert_eq(player.get_state(), PlayerState.State.INTERACTING)
	
func test_player_take_damage_should_subtract_health_and_change_state():
	player.take_damage(20)
	assert_eq(player.get_health(), 80)
	assert_eq(player.get_state(), PlayerState.State.DAMAGED)
	
func test_player_health_below_zero_should_kill():
	player.take_damage(120)
	assert_eq(player.get_health(), 0)
	assert_eq(player.get_state(), PlayerState.State.DEAD)
	
func test_player_change_state_to_walk():
	player.change_state(PlayerState.State.WALKING)
	assert_eq(player.get_state(), PlayerState.State.WALKING)
	player._state = PlayerState.State.JUMPING
	player.change_state(PlayerState.State.WALKING)
	assert_eq(player.get_state(), PlayerState.State.JUMPING, "Should not change to walk when jumping")
	
func test_player_change_state_to_jump():
	player.change_state(PlayerState.State.JUMPING)
	assert_eq(player.get_state(), PlayerState.State.JUMPING)
	player._state = PlayerState.State.ATTACKING
	player.change_state(PlayerState.State.JUMPING)
	assert_eq(player.get_state(), PlayerState.State.ATTACKING, "Jump only allowed when walking or idle")
	
func test_player_change_state_to_attack():
	player.change_state(PlayerState.State.ATTACKING)
	assert_eq(player.get_state(), PlayerState.State.ATTACKING)
	player._state = PlayerState.State.DAMAGED
	player.change_state(PlayerState.State.ATTACKING)
	assert_eq(player.get_state(), PlayerState.State.DAMAGED, "Player should only attack when idle, walking or jumping")
	
func test_player_change_state_to_interact():
	player.change_state(PlayerState.State.INTERACTING)
	assert_eq(player.get_state(), PlayerState.State.INTERACTING)
	player._state = PlayerState.State.WALKING
	player.change_state(PlayerState.State.INTERACTING)
	assert_eq(player.get_state(), PlayerState.State.WALKING, "Player should only interact while IDLE")
	
func test_player_change_state_to_idle():
	player.change_state(PlayerState.State.WALKING)
	player.change_state(PlayerState.State.IDLE)
	assert_eq(player.get_state(), PlayerState.State.IDLE)
	player.change_state(PlayerState.State.JUMPING)
	player.change_state(PlayerState.State.IDLE)
	assert_eq(player.get_state(), PlayerState.State.JUMPING, "Player should only go idle when walking")
	player._state = PlayerState.State.ATTACKING
	player.change_state(PlayerState.State.IDLE)
	assert_eq(player.get_state(), PlayerState.State.IDLE, "Player should change to idle after attack")
	
func test_landing():
	player.change_state(PlayerState.State.JUMPING)
	player.land()
	assert_eq(player.get_state(), PlayerState.State.IDLE)
