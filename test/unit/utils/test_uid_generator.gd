extends GutTest

func test_uid_generator_check_prefix():
	var uid: String = UIDGenerator.generate("test")
	assert_string_starts_with(uid, "test-")
	
func test_generate_many_uids_should_never_repeat():
	var list: Array[String] = []
	for i in range(10000):
		var uid: String = UIDGenerator.generate("test")
		list.append(uid)
		
	while not list.is_empty():
		var uid: String = list.pop_front()
		assert_false(list.has(uid), "UID " + uid + " is repeated!!")
