extends FilterAmount
class_name FilterStat

@export
var amount : float


@export
var percentage : bool

@export
var stat : String


@export
var comparison : Helper.Comparison


func check_amount(char : CharacterData) -> bool:
	var check_value = 0
	if percentage:
		check_value = char.get(stat).value/char.get(stat).default
	else:
		check_value = char.get(stat).value
	return Helper.comparison(check_value, amount, comparison)
	pass
