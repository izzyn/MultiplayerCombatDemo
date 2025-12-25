extends Resource
class_name CharacterData

@export_group("","")
@export
var id : String

@export
var name : String

@export
var team : bool

@export_group("Stats")
@export
var hp : Stat

@export
var normal_attack : Stat

@export
var magic_attack : Stat

@export
var normal_defence : Stat

@export
var magic_defence : Stat

@export
var speed : Stat

@export
var targetability_factor : float = 1

@export_group("AI Stats")
enum Playstyle {Buff, Debuff, Attack}
var playstyle : Playstyle

@export_group("","")
@export
var attack_ids : Array[String]

var sprite : CharacterSprite

var _statuses : Array[Status]
signal _statuses_changed

signal on_death

func reduce_status_duration(status : Status, amount : int) -> bool:
	var marked_for_deletion : Array[StackSource] = []
	for i in status._stack_sources:
		i.duration_left -= amount
		if i.duration_left <= 0:
			marked_for_deletion.append(i)
	for i in marked_for_deletion:
		status._stack_sources.erase(i)
	if status.stacks == 0:
		return true
	else:
		return false



func stat_changed(stat_name : String, old_value : float, new_value : float):
	if stat_name == "hp" and old_value > new_value:
		if new_value <= 0:
			pre_death()
			if hp.value <= 0:
				on_death.emit()
		var marked_for_deletion : Array[Status] = []
		for i in _statuses:
			if reduce_status_duration(i, i.duration_on_hit):
				marked_for_deletion.append(i)
			if i.duration_on_hit != 0:
				_statuses_changed.emit()
		for i in marked_for_deletion:
			_statuses.erase(i)
			_statuses_changed.emit()
	pass

func pre_death():
	pass

func turn_changed(turn : int):
	var marked_for_deletion : Array[Status] = []
	for i in _statuses:
		if reduce_status_duration(i, i.duration_on_turn):
			marked_for_deletion.append(i)
		if i.duration_on_turn != 0:
			_statuses_changed.emit()
	for i in marked_for_deletion:
		_statuses.erase(i)
		_statuses_changed.emit()
	pass
