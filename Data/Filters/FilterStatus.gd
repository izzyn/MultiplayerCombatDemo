extends FilterAmount
class_name FilterStatus

@export
var status_id : String

@export
var status_amount : int

@export
var comparison : Helper.Comparison

func check_amount(char : CharacterData) -> bool:
	for status in char._statuses:
		if status.id == status_id:
			return Helper.comparison(status.stacks, status_amount, comparison)
	return Helper.comparison(0, status_amount, comparison)
	pass
