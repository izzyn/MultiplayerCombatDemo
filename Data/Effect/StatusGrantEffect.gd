extends Effect
class_name StatusGrantEffect

@export
var status : Status

## If -1 (or less than 0 in general) the duration will be forever.
@export
var duration : int

@export
var amount : int = 1

func on_status_granted(target : CharacterAgent, caller, id : int):
	if duration > 0:
		var timer = CombatSimulator.create_turn_timeout(duration)
		timer.timeout.connect(remove_status.bind(target, id))
	target.data._statuses_changed.emit()
	pass

func grant_stacks(status: Status, id : int):
	for i in range(amount):
		status._stack_sources.append(id)

func enact(user : CharacterAgent, target : CharacterAgent, effectiveness : float):
	var attack_id = Helper.get_uuid()
	for t_status in target.data._statuses:
		if t_status.id == status.id:
			if status.stackable:
				grant_stacks(t_status, attack_id)
				on_status_granted(target, user, attack_id)
			return
	
	var n_status = status.duplicate()
	target.data._statuses.append(n_status)
	grant_stacks(n_status, attack_id)
	on_status_granted(target, user, attack_id)
	pass

func remove_status(target : CharacterAgent, id : int):
	var found_status
	for t_status in target.data._statuses:
		if t_status.id == status.id:
			found_status = t_status
			break 
	if found_status:
		for i in range(amount):
			if found_status.stacks > 1:
				found_status._stack_sources.erase(id)
			else:
				target.data._statuses.erase(found_status)
		target.data._statuses_changed.emit()
		print("removed statuses")
	pass
