extends Filter
class_name FilterTag

@export
var tag_name : String

func _eval(actor: CharacterData, characters : Array[CharacterData]) -> Array[CharacterData]:
	var list : Array[CharacterData] = []
	for character in characters:
		var found = false
		if !character.tags:
			continue
		for tag in character.get_tags():
			if tag.tag_name == tag_name:
				found = true
		if found:
			list.append(character)
	return list
