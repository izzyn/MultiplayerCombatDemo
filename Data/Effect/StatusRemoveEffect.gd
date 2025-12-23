extends Effect
class_name StatusRemoveEffect

## If left as -1 it clears all.
@export
var amount : int = -1

@export
var status_id : String

@export
var clears_all : bool = false
func enact(user : CharacterAgent, target : CharacterAgent, effectiveness : float):
	for index in range(target.data._statuses.size()):
		if target.data._statuses[index].id == status_id or clears_all:
			if target.data._statuses[index].stacks > amount and amount != -1:
				for i in range(amount):
					if target.data._statuses[index].stacks > 1:
						target.data._statuses[index]._stack_sources.pop_back()
					else:
						target.data._statuses.erase(target.data._statuses[index])
			else:
				target.data._statuses.erase(target._statuses[index])
			target.data._statuses_changed.emit()
	pass
