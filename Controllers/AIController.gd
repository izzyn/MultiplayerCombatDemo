extends CharacterController
class_name AIController

func request_action(user : CharacterAgent, characters : Array[CharacterAgent]) -> CharacterAction:
	var highest_weight = -1
	var picked_attack : AttackData
	var action = CharacterAction.new()
	action.user = user
	var possible_targets : Array[CharacterAgent] = []
	var all_characters = characters

	var rng = RandomNumberGenerator.new()
	for i in user.data.attacks:
		var type_mult = 1
		if user.data.playstyle == user.data.Playstyle.Attack:
			if i.type == i.Type.Attack:
				type_mult = 2
			if i.type == i.Type.Debuff:
				type_mult = 1.5
		elif user.data.playstyle == user.data.Playstyle.Buff:
			if i.type == i.Type.Buff:
				type_mult = 2
			if i.type == i.Type.Debuff:
				type_mult = 1.5
		elif user.data.playstyle == user.data.Playstyle.Debuff:
			if i.type == i.Type.Debuff:
				type_mult = 2
			if i.type == i.Type.Attack:
				type_mult = 1.5
		var weight = i.base_ai_weight * type_mult * rng.randf_range(1,1.5)
		var attack_targets = characters
		if i.target_filter:
			attack_targets = i.target_filter.eval(user, characters)
		
		if len(attack_targets) == 0:
			weight = 0
		if weight > highest_weight:
			highest_weight = weight
			picked_attack = i
	action.action = picked_attack
	if picked_attack.target_filter:
		possible_targets = picked_attack.target_filter.eval(user, all_characters)
	else:
		possible_targets = all_characters
	if picked_attack.hits_all:
		action.targets = possible_targets
		return action
	if len(possible_targets) == 0:
		return ActionError.new()
	for targets_left in range(min(picked_attack.target_amount, len(possible_targets))):
		var highest_weight_target = -1
		var picked_target : CharacterData
		var weight_list = []
		for target in possible_targets:
			#Ensures the enemy tries to not kill itself or its allies :p
			var hostility_factor = 1
			if target.data.team != user.data.team and picked_attack.type == picked_attack.Type.Buff:
				hostility_factor = 0.01
			elif target.data.team == user.data.team and picked_attack.type != picked_attack.Type.Buff:
				hostility_factor = 0.01
			var weight = target.data.targetability_factor * hostility_factor
			weight_list.append([weight, target])
		action.targets.append(Helper.random_list_get(weight_list))
		if !picked_attack.can_target_multiple_times:
			possible_targets.erase(picked_target)
	
	return action
	
