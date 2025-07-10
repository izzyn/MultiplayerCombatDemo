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

@export_group("Extra effects")
@export
var additional_effects : Array[SecondaryEffect]
## Modifiers in this field can only be offensive, defensive modifiers in this field will simply work asif disabled.
@export
var modifiers : Array[Modifier]

func use_attack(user : CharacterData, targets : Array[CharacterData], caller : CharacterSprite):
	var effectiveness_dict = {}
	for target in targets:
		effectiveness_dict[target] = 1
		for scale in scale_stats:
			var value = user.get(scale.stat_name).value/100
			effectiveness_dict[target] += value * scale.scale_weight
	
	var total_modifiers : Array[Modifier] = []
	total_modifiers.append_array(modifiers)
	
	for status in user._statuses:
		total_modifiers.append_array(status.modifiers)
	
	for mod in total_modifiers:
		if mod.type == Modifier.Type.Offensive:
			var affected = mod.filter.eval(user, targets)
			for aff in affected:
				effectiveness_dict[aff] *= mod.value
					
	for target in targets:
		for status in target._statuses:
			for mod in status.modifiers:
				if mod.type == Modifier.Type.Defensive:
					var arr : Array[CharacterData] = []
					arr.append(user)
					var use = len(mod.filter.eval(target, arr)) == 1
					if use: effectiveness_dict[target] *= mod.value
	
	for target in targets:
		var total_effects : Array[Effect] = []
		total_effects.append_array(effects)
		for status in user._statuses:
			if status.additional_effect:
				for effect in status.additional_effect:
					if target in effect.condition.eval(user, [target]):
						total_effects.append_array(effect.effects)
					
		for effect in total_effects:
			effect.enact(user, target, effectiveness_dict[target], caller)
		pass
