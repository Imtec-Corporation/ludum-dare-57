class_name UIDGenerator

static func generate(prefix: String = "") -> String:
	var uid: String = prefix + "-"
	var timestamp = Time.get_ticks_msec()
	var rnd = randi_range(0, 9999999)
	var rnd2 = randi()
	uid += String.num_int64(rnd2) + (
		"-" + 
		String.num_int64(timestamp) + 
		"-" + 
		String.num_int64(rnd)
		)
	return uid
