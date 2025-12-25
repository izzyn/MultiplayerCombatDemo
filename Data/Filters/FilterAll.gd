extends Filter
class_name FilterAll

@export
var filters : Array[Filter]

func _eval(actor: CharacterData, characters : Array[CharacterData]) -> Array[CharacterData]:
	var list = characters
	for i in filters:
		list = i._data_eval(actor, list)
	return list
