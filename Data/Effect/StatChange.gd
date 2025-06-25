extends Effect
class_name StatChange

enum Type {Value, Default}

@export
var type : Type

@export
var exceed_default : bool = false

@export
var stat_name : String

func enact(user : CharacterData, target : CharacterData, effectiveness : float):
	var stat = target.get(stat_name)
	var true_amount = amount * effectiveness
	if type == Type.Value:
		if exceed_default:
			stat.value += true_amount
		else:
			stat.value = clamp(stat.value+true_amount,0,stat.default)
	elif type == Type.Default:
		stat.default += true_amount
		

	pass
