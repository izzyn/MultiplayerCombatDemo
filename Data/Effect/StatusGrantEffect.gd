extends Effect
class_name StatusGrantEffect

@export
var status : Status

@export
var duration : float

func on_status_granted(target : CharacterData, caller):
	var timer = caller.get_tree().create_timer(duration)
	timer.timeout.connect(remove_status.bind(target))
	target._statuses_changed.emit()
	pass
func enact(user : CharacterData, target : CharacterData, effectiveness : float, caller : CharacterSprite):
	for t_status in target._statuses:
		if t_status.id == status.id:
			if status.stackable:
				t_status.stacks += 1
				on_status_granted(target, caller)
			return
	
	target._statuses.append(status)
	on_status_granted(target, caller)
	pass

func remove_status(target : CharacterData):
	var index = target._statuses.find(status)
	print(index)
	if index != -1:
		if target._statuses[index].stacks > 1:
			target._statuses[index].stacks -= 1
		else:
			target._statuses.erase(status)
		target._statuses_changed.emit()
	pass
