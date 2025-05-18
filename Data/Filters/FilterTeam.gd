extends Filter
class_name FilterTeam

func _eval(actor: CharacterData, characters : Array[CharacterData]) -> Array[CharacterData]:
	var list : Array[CharacterData] = []
	for i in characters:
		if i.team == actor.team:
			list.append(i)
	return list
	pass
