extends GutTest

func test_enemy_should_be_created_with_default_health():
	var enemy = Enemy.new(10, 1, true)
	assert_eq(enemy._health, 10)
	assert_not_null(enemy._fsm)
	assert_eq(enemy.get_state(), EnemyState.State.IDLE)
	assert_true(enemy._attacks)
	assert_eq(enemy._direction, Direction.Values.RIGHT)
	assert_false(enemy._isActive)
	
func test_activate_should_raise_flag():
	var enemy = Enemy.new(1, 1, true)
	enemy.activate()
	assert_true(enemy._isActive)
	
func test_deactivate_should_lower_flag():
	var enemy = Enemy.new(1, 1, true)
	enemy.activate()
	enemy.deactivate()
	assert_false(enemy._isActive)
	
func test_activation_should_change_status_to_patrol():
	var enemy = Enemy.new(1, 1, true)
	enemy.activate()
	enemy.update()
	assert_eq(enemy.get_state(), EnemyState.State.PATROL)
	
func test_should_attack_when_walking_and_target_in_range():
	var enemy = Enemy.new(1, 1, true)
	enemy.activate()
	enemy.update()
	enemy.targetInRange = true
	enemy.update()
	assert_eq(enemy.get_state(), EnemyState.State.ATTACK)
	
func test_should_not_attack_when_walking_and_target_in_range_but_not_attacks():
	var enemy = Enemy.new(1, 1, false)
	enemy.activate()
	enemy.update()
	enemy.targetInRange = true
	enemy.update()
	assert_eq(enemy.get_state(), EnemyState.State.PATROL)
	
func test_should_attack_when_jumping_and_target_in_range():
	var enemy = Enemy.new(1, 1, true)
	enemy._fsm._state = EnemyState.State.JUMP
	enemy.targetInRange = true
	enemy.update()
	assert_eq(enemy.get_state(), EnemyState.State.ATTACK)
	
func test_should_jump_left_when_left_tier_found():
	var enemy = Enemy.new(1, 1, true)
	enemy.activate()
	enemy.update()
	enemy.leftTier = true
	enemy.leftWall = true
	enemy.update()
	assert_eq(enemy.get_state(), EnemyState.State.JUMP)
	
func test_should_not_jump_left_when_left_tier_incomplete():
	var enemy = Enemy.new(1, 1, true)
	enemy.activate()
	enemy.update()
	enemy.leftTier = true
	enemy.update()
	assert_eq(enemy.get_state(), EnemyState.State.PATROL)
	
func test_should_jump_right_when_right_tier_found():
	var enemy = Enemy.new(1, 1, true)
	enemy.activate()
	enemy.update()
	enemy.rightTier = true
	enemy.rightWall = true
	enemy.update()
	assert_eq(enemy.get_state(), EnemyState.State.JUMP)
	
func test_should_not_jump_left_when_right_tier_incomplete():
	var enemy = Enemy.new(1, 1, true)
	enemy.activate()
	enemy.update()
	enemy.rightTier = true
	enemy.update()
	assert_eq(enemy.get_state(), EnemyState.State.PATROL)
	
func test_should_change_to_patrol_when_landed_after_jump():
	var enemy = Enemy.new(1 ,1, true)
	enemy._fsm._state = EnemyState.State.JUMP
	enemy.landed = true
	enemy.update()
	assert_eq(enemy.get_state(), EnemyState.State.PATROL)
	
func test_should_change_to_damaged_when_receiving_attack():
	var enemy = Enemy.new(1, 1, true)
	enemy.beingDamaged = true
	enemy.update()
	assert_eq(enemy.get_state(), EnemyState.State.DAMAGED)
	
func test_should_return_to_idle_after_damaged():
	var enemy = Enemy.new(1, 1, true)
	enemy.beingDamaged = false
	enemy._fsm._state = EnemyState.State.DAMAGED
	enemy.update()
	assert_eq(enemy.get_state(), EnemyState.State.IDLE)
	
func test_should_die_after_damage_with_no_health():
	var enemy = Enemy.new(0, 1, true)
	enemy.beingDamaged = false
	enemy._fsm._state = EnemyState.State.DAMAGED
	enemy.update()
	assert_eq(enemy.get_state(), EnemyState.State.DEAD)
	
func test_should_return_to_idle_after_attack():
	var enemy = Enemy.new(1, 1, true)
	enemy.attackFinished = true
	enemy._fsm._state = EnemyState.State.ATTACK
	enemy.update()
	assert_eq(enemy.get_state(), EnemyState.State.IDLE)
	
func test_should_turn_left_when_detecting_wall_at_right():
	var enemy = Enemy.new(1, 1, true)
	enemy.activate()
	enemy.update()
	enemy.rightWall = true
	enemy.rightTier = false
	enemy.update()
	assert_eq(enemy.get_direction(), Direction.Values.LEFT)
	
func test_should_turn_right_when_detecting_wall_at_left():
	var enemy = Enemy.new(1, 1, true)
	enemy._direction = Direction.Values.LEFT
	enemy.activate()
	enemy.update()
	enemy.leftWall = true
	enemy.leftTier = false
	enemy.update()
	assert_eq(enemy.get_direction(), Direction.Values.RIGHT)
	
func test_should_turn_left_when_detecting_fall_at_left():
	var enemy = Enemy.new(1, 1, true)
	enemy.activate()
	enemy.update()
	enemy.rightFall = true
	enemy.update()
	assert_eq(enemy.get_direction(), Direction.Values.LEFT)
	
func test_should_turn_right_when_detecting_fall_at_right():
	var enemy = Enemy.new(1, 1, true)
	enemy.activate()
	enemy._direction = Direction.Values.LEFT
	enemy.update()
	enemy.leftFall = true
	enemy.update()
	assert_eq(enemy.get_direction(), Direction.Values.RIGHT)
	
func test_should_decrease_health_when_taking_damage():
	var enemy = Enemy.new(10, 1, true)
	enemy.activate()
	enemy.update()
	enemy.take_damage(1)
	enemy.update()
	assert_eq(enemy.get_health(), 9)
	assert_eq(enemy.get_state(), EnemyState.State.DAMAGED)
	
func test_health_should_not_go_below_zero_when_attacked():
	var enemy = Enemy.new(1, 1, true)
	enemy.take_damage(5)
	enemy.update()
	assert_eq(enemy.get_health(), 0)
	enemy.beingDamaged = false
	enemy.update()
	assert_eq(enemy.get_state(), EnemyState.State.DEAD)
