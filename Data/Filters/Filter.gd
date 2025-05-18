extends Resource
class_name Filter

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
		return actual
	else:
		return filtered
	pass
