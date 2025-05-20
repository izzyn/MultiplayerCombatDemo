extends Resource
class_name AttackData

@export_group("Cosmetic")
@export var id : String
@export var name : String

@export_group("Metadata")
enum Type {Buff, Debuff, Attack, Special}
enum Statistic {HP, Attack, Special}

@export
var type : Type
@export
var stat : Statistic
@export
var base_ai_weight : float = 10

@export_group("Targeting and Effect")
@export
var hits_all : bool = false

@export
var can_target_multiple_times : bool = false

@export
var cooldown : float = 5

@export
var target_amount : int = 1

@export
var target_filter : Filter
@export
var effects : Array[Effect]

func use_attack(user : CharacterData, targets : Array[CharacterData]):
	for target in targets:
		for effect in effects:
			effect.enact(target)
	pass
