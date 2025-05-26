extends Filter
class_name FilterStat

@export
var amount : float

@export
var actor_stat : bool

@export
var percentage : bool

@export
var stat : String

enum Comparison {Greater_Equal, Greater, Equal, Lesser_Equal, Lesser}

@export
var comparison : Comparison

func _eval(actor: CharacterData, characters : Array[CharacterData]) -> Array[CharacterData]:
	if actor_stat:
		if check_stat(actor):
			return characters
		else:
			return []
	else:
		return characters.filter(func(x): return check_stat(x))
	return []
	pass
func check_stat(char : CharacterData) -> bool:
	var check_value = 0
	if percentage:
		check_value = char.get(stat).value/char.get(stat).default
	else:
		check_value = char.get(stat).value
	print(char.get(stat).value)
	print(char.get(stat).default)
	print(check_value)
	print(amount)
	match comparison:
		Comparison.Greater_Equal:
			return check_value >= amount
		Comparison.Greater:
			return check_value > amount
		Comparison.Equal:
			return check_value == amount
		Comparison.Lesser_Equal:
			return check_value <= amount
		Comparison.Lesser:
			return check_value < amount
	return false
	pass
