extends Filter
## This is a virtual class not intended for use, it is used by other filters that check amounts of things (Like stats or status effects)
class_name FilterAmount
@export
var actor_stat : bool

func _eval(actor: CharacterData, characters : Array[CharacterData]) -> Array[CharacterData]:
	if actor_stat:
		if check_amount(actor):
			return characters
		else:
			return []
	else:
		return characters.filter(func(x): return check_amount(x))
	return []
	pass

func check_amount(character : CharacterData) -> bool:
	return false
	pass
