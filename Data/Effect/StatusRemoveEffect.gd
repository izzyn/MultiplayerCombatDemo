extends Effect
class_name StatusRemoveEffect

## If left as -1 it clears all.
@export
var amount : int = -1

@export
var status_id : String

@export
var clears_all : bool = false
func enact(user : CharacterData, target : CharacterData, effectiveness : float, caller : CharacterSprite):
	for index in range(target._statuses.size()):
		if target._statuses[index].id == status_id or clears_all:
			if target._statuses[index].stacks > amount and amount != -1:
				for i in range(amount):
					if target._statuses[index].stacks > 1:
						target._statuses[index]._stack_sources.pop_back()
					else:
						target._statuses.erase(target._statuses[index])
			else:
				target._statuses.erase(target._statuses[index])
			target._statuses_changed.emit()
	pass
