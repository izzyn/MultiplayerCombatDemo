extends Node

var rng = RandomNumberGenerator.new()
enum Comparison {Greater_Equal, Greater, Equal, Lesser_Equal, Lesser}

var last_uuid = 0
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

func get_uuid() -> int:
	var old_uuid = last_uuid
	last_uuid += 1
	return old_uuid

func comparison(item1 : float, item2 : float, comparison : Comparison) -> bool:
	print("item 1: %s" %item1)
	print("item 2: %s" % item2)
	match comparison:
		Comparison.Greater_Equal:
			return item1 >= item2
		Comparison.Greater:
			return item1 > item2
		Comparison.Equal:
			return item1 == item2
		Comparison.Lesser_Equal:
			return item1 <= item2
		Comparison.Lesser:
			return item1 < item2
	return false
	pass
