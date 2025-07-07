extends Resource
class_name Filter

@export
var can_target_dead : bool = false
@export
var inverted : bool
func _eval(actor: CharacterData, characters : Array[CharacterData]) -> Array[CharacterData]:
	return []
	pass

func eval(actor: CharacterData, characters : Array[CharacterData]) -> Array[CharacterData]:
	var filtered = _eval(actor, characters)
	var actual : Array[CharacterData] = []
	if inverted:
		for i in characters:
			if i not in filtered:
				actual.append(i)
		actual
	else:
		actual = filtered
	
	if !can_target_dead:
		actual = actual.filter(func(x): return x.hp.value > 0)
	return actual
	pass
