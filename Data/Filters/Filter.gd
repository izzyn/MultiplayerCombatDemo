extends Resource
class_name Filter

@export
var can_target_dead : bool = false
@export
var inverted : bool
func _eval(actor: CharacterData, characters : Array[CharacterData]) -> Array[CharacterData]:
	return []
	pass

func eval(actor: CharacterAgent, characters : Array[CharacterAgent]) -> Array[CharacterAgent]:
	var agent_dict : Dictionary[CharacterData, CharacterAgent] = {}
	for agent in characters:
		agent_dict[agent.data] = agent
	var data : Array[CharacterData] = []
	for i in characters:
		data.append(i.data)
	print(agent_dict)
	var filtered = _eval(actor.data, data)
	var actual : Array[CharacterData] = []
	var result : Array[CharacterAgent] = []
	if inverted:
		for i in data:
			if i not in filtered:
				actual.append(i)
	else:
		actual = filtered
	
	if !can_target_dead:
		actual = actual.filter(func(x): return x.hp.value > 0)
	for i in actual:
		result.append(agent_dict[i])
	return result
