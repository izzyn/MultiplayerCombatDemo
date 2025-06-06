extends Resource
class_name AttackData

@export_group("Cosmetic")
@export var id : String
@export var name : String

@export_group("Metadata")
enum Type {Buff, Debuff, Attack, Special}
enum Statistic {HP, NAttack, MAttack, NDef, MDef, Speed}

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
var scale_stats : Array[ScaleFactor]

@export
var effects : Array[Effect]

@export
var additional_effects : Array[SecondaryEffect]

func use_attack(user : CharacterData, targets : Array[CharacterData]):
	var start_effectiveness = user._attack_effectiveness
	for scale in scale_stats:
		var value = user.get(scale.stat_name).value/100
		user._attack_effectiveness += start_effectiveness * value * scale.scale_weight
		
	for add in additional_effects:
		var increased_effectiveness = false
		var filtered = add.condition.eval(user, targets)
		for target in filtered:
			for effect in add.effects:
				effect.enact(user,target)
				if effect is EffectivenessEffect:
					increased_effectiveness = true
					break
			if increased_effectiveness:
				break
		
	for target in targets:
		for effect in effects:
			effect.enact(user, target)
	
	user._attack_effectiveness = 1
	pass
