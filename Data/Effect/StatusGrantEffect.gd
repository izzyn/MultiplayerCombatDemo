extends Effect
class_name StatusGrantEffect

@export
var status_id : String

## If -1 (or less than 0 in general) the duration will be forever.
@export
var duration : int

@export
var amount : int = 1

func grant_stacks(status: Status, target : CharacterAgent):
	for i in range(amount):
		var source = StackSource.new()
		source.duration_left = duration
		source.turn_granted = CombatSimulator.turn
		status._stack_sources.append(source)
		target.data._statuses_changed.emit()
		

func enact(user : CharacterAgent, target : CharacterAgent, effectiveness : float):
	var attack_id = Helper.get_uuid()
	var status = GlobalData.fetch_status(status_id).duplicate_deep()
	for t_status in target.data._statuses:
		if t_status.id == status.id:
			if status.stackable:
				grant_stacks(t_status, target)
			return
	
	var n_status = status.duplicate()
	target.data._statuses.append(n_status)
	grant_stacks(n_status, target)
	pass
