extends Node
class_name StatusGrantEffect

@export
var status : Status

func enact(user : CharacterData, target : CharacterData, effectiveness : float):
	for t_status in target._statuses:
		if t_status.id == status.id:
			if status.stackable:
				t_status.stacks += 1
	pass
