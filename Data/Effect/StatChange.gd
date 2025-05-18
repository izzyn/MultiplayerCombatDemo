extends Effect
class_name StatChange

enum Type {Value, Default}

@export
var type : Type

@export
var amount : float

@export
var exceed_default : bool = false

@export
var stat_name : String

func enact(target : CharacterData):
	var stat = target.get(stat_name)
	print(stat)
	print(target.hp)
	if type == Type.Value:
		if exceed_default:
			stat.value += amount
		else:
			stat.value = clamp(stat.value+amount,0,stat.default)
			print(stat.value)
			print(target.hp.value)
	elif type == Type.Default:
		stat.default += amount

	pass
