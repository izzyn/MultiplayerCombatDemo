extends Node

var rng = RandomNumberGenerator.new()

func random_list_get(list : Array):
	var sum = 0
	for weight in list:
		sum += weight[0]
	
	var randomnr = rng.randf_range(0, sum)
	var psum = 0
	
	for weight in range(len(list)):
		psum += list[weight][0]
		if (psum > randomnr):
			return list[weight][1]
	return list[len(list)-1][1]
	pass
