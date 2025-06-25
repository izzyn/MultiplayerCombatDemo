extends Filter
class_name FilterAny

@export
var filters : Array[Filter]

func _eval(actor : CharacterData, characters : Array[CharacterData]) -> Array[CharacterData]:
	var list : Array[CharacterData] = []
	
	for i in filters:
		var filtered_list = i.eval(actor, characters)
		for j in filtered_list:
			if j not in list:
				list.append(j)
	return list
	pass
