extends GutTest

class TestHelper:
	var called: bool = false
	
	func predicate():
		self.called = true
		return true
		
class PredicateTrue:
	func predicate(): return true
	
class PredicateFalse:
	func predicate(): return false
	
func test_state_map_should_be_not_null_and_empty():
	var fsm = EnemyFSM.new()
	assert_not_null(fsm._stateMap)
	assert_eq(fsm._stateMap.size(), 0)
	assert_eq(fsm._state, EnemyState.State.IDLE)
	
func test_state_map_should_insert_state_predicate_pair():
	var fsm = EnemyFSM.new()
	var transition = EnemyStateTransition.new(EnemyState.State.PATROL, func(): pass)
	fsm.add_transition(EnemyState.State.IDLE, transition)
	assert_eq(fsm._stateMap.size(), 1)
	
func test_tick_should_invoke_predicate():
	var called: bool = false
	var fsm = EnemyFSM.new()
	assert_eq(fsm.get_state(), EnemyState.State.IDLE)
	var helper = TestHelper.new()
	var transition = EnemyStateTransition.new(EnemyState.State.PATROL, helper.predicate)
	fsm.add_transition(EnemyState.State.IDLE, transition)
	assert_true(fsm._stateMap.keys().has(EnemyState.State.IDLE))
	fsm.tick()
	assert_true(helper.called)
	
func test_should_change_state_when_predicate_matches():
	var fsm = EnemyFSM.new()
	assert_eq(fsm.get_state(), PlayerState.State.IDLE)
	var helper = PredicateTrue.new()
	var transition = EnemyStateTransition.new(EnemyState.State.PATROL, helper.predicate)
	fsm.add_transition(EnemyState.State.IDLE, transition)
	fsm.tick()
	assert_eq(fsm.get_state(), EnemyState.State.PATROL)
	
func test_should_not_change_state_when_predicate_fails():
	var fsm = EnemyFSM.new()
	assert_eq(fsm.get_state(), PlayerState.State.IDLE)
	var helper = PredicateFalse.new()
	var transition = EnemyStateTransition.new(EnemyState.State.PATROL, helper.predicate)
	fsm.add_transition(EnemyState.State.IDLE, transition)
	fsm.tick()
	assert_eq(fsm.get_state(), EnemyState.State.IDLE)
	
func test_should_handle_multiple_transitions():
	var fsm = EnemyFSM.new()
	var trueHelper = PredicateTrue.new()
	var falseHelper = PredicateFalse.new()
	var transition1 = EnemyStateTransition.new(EnemyState.State.PATROL, falseHelper.predicate)
	var transition2 = EnemyStateTransition.new(EnemyState.State.JUMP, trueHelper.predicate)
	fsm.add_transition(EnemyState.State.IDLE, transition1)
	fsm.add_transition(EnemyState.State.IDLE, transition2)
	fsm.tick()
	assert_eq(fsm.get_state(), EnemyState.State.JUMP)
	
func test_should_get_first_transition_when_all_match():
	var fsm = EnemyFSM.new()
	var trueHelper = PredicateTrue.new()
	var falseHelper = PredicateFalse.new()
	var transition1 = EnemyStateTransition.new(EnemyState.State.PATROL, trueHelper.predicate)
	var transition2 = EnemyStateTransition.new(EnemyState.State.JUMP, trueHelper.predicate)
	fsm.add_transition(EnemyState.State.IDLE, transition1)
	fsm.add_transition(EnemyState.State.IDLE, transition2)
	fsm.tick()
	assert_eq(fsm.get_state(), EnemyState.State.PATROL)
	
	
	
