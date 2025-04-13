extends GutTest

class TestHelper:
	var called: bool = false
	
	func predicate():
		self.called = true
		return true
		
class PredicateTrue:
	func predicate(): return true
	
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
	
	
