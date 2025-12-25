extends Node

var input_requested : bool = false
var inputting_character : CharacterAgent 
signal input_sent(action : CharacterAction)

var focused_character : CharacterAgent:
	set(value):
		if focused_character and focused_character.linked_sprite:
			if value and value.linked_sprite:
				focused_character.linked_sprite.character_focus_changed(value)
			else:
				focused_character.linked_sprite.character_defocused()
		if value and value.linked_sprite:
			value.linked_sprite.character_focused()
		focused_character = value

var selected_character : CharacterAgent:
	set(value):
		if selected_character and selected_character.linked_sprite:
			selected_character.linked_sprite.character_deselected()
		if value and value.linked_sprite:
			value.linked_sprite.character_selected()
		selected_character = value

var focused_target : CharacterAgent:
	set(value):
		if value == focused_target:
			pass
		if focused_target and focused_target.linked_sprite:
			if value and value.linked_sprite:
				focused_target.linked_sprite.attack_target_focus_changed(value)
			else:
				focused_target.linked_sprite.attack_target_defocused()
		if value and value.linked_sprite:
			value.linked_sprite.attack_target_focused()
		focused_target = value

var attack_index : int:
	set(value):
		var old = attack_index
		attack_index = value
		if value == attack_index:
			pass
		if inputting_character and inputting_character.linked_sprite: 
			inputting_character.linked_sprite.attack_index_changed(old, value)

var target_index : int
var character_index : int
var selected_attack : AttackData
var focused_attack : AttackData
var possible_targets : Array[CharacterAgent]
var selected_targets : Array[CharacterAgent]

var all_characters : Array[CharacterAgent]
func _input(event: InputEvent) -> void:
	if !input_requested:
		pass
	if event.is_action_pressed("NavigateUp"):
		if selected_attack:
			if target_index == possible_targets.size()-1:
				target_index = 0
			else:
				target_index += 1
			focused_target = possible_targets[target_index]
		elif selected_character:
			if attack_index == selected_character.data.attack_ids.size()-1:
				attack_index = 0
			else:
				attack_index += 1
			focused_attack = GlobalData.attacks[selected_character.data.attack_ids[attack_index]]
	if event.is_action_pressed("NavigateDown"):
		if selected_attack:
			if target_index == 0:
				target_index = possible_targets.size()-1
			else:
				target_index -= 1
			focused_target = possible_targets[target_index]
		elif selected_character:
			if attack_index == 0:
				attack_index = selected_character.data.attack_ids.size()-1
			else:
				attack_index -= 1
			focused_attack = GlobalData.attacks[selected_character.data.attack_ids[attack_index]]
	if event.is_action_pressed("Confirm"):
		if selected_attack:
			if selected_attack.hits_all:
				send_input(inputting_character, selected_attack, selected_targets)
				return
			selected_targets.append(focused_target)
			if focused_target.linked_sprite:
				focused_target.linked_sprite.attack_target_selected()
			if selected_targets.size() == selected_attack.target_amount:
				send_input(inputting_character, selected_attack, selected_targets)
				return
			else:
				if !selected_attack.can_target_multiple_times:
					if possible_targets.find(focused_target) == possible_targets.size()-1:
						target_index = 0
					possible_targets.erase(focused_target)
					if possible_targets.size() == 0:
						send_input(inputting_character, selected_attack, selected_targets)
						return
					focused_target = possible_targets[attack_index]
		elif selected_character:
			selected_attack = focused_attack
			if selected_attack.target_filter:
				possible_targets = selected_attack.target_filter.eval(inputting_character, all_characters)
			else:
				possible_targets = all_characters.duplicate()
			print(possible_targets.size())
			
			if selected_attack.hits_all:
				for i in possible_targets:
					selected_targets.append(i)
					if i.linked_sprite:
						i.linked_sprite.attack_target_selected()
			if possible_targets.size() == 0:
				selected_attack = null
				return
			print(possible_targets.size())
			focused_target = possible_targets[0] 
		else:
			selected_character = focused_character
	if event.is_action_pressed("Escape"):
		if selected_attack:
			selected_attack = null
			reset_selections()
			focused_target = null
		#elif selected_character:
			#selected_character = null
			#attack_index = 0
	pass

func send_input(user : CharacterAgent, action : AttackData, targets : Array[CharacterAgent]):
	var result = CharacterAction.new()
	result.action = selected_attack.duplicate()
	result.user = inputting_character.duplicate()
	result.targets = selected_targets.duplicate_deep()
	input_sent.emit(result)
	pass

func reset_selections():
	for i in selected_targets:
		if i.linked_sprite:
			i.linked_sprite.attack_target_defocused()
			i.linked_sprite.attack_target_deselected()
	selected_targets.clear()
	possible_targets.clear()
	pass

func request_input(user : CharacterAgent, characters : Array[CharacterAgent]):
	input_requested = true
	inputting_character = user
	all_characters = characters
	selected_character = user
	focused_attack = GlobalData.attacks[user.data.attack_ids[0]]
	var result = await input_sent
	target_index = 0
	attack_index = 0
	focused_target = null
	focused_character = null
	selected_attack = null
	selected_character = null
	input_requested = false
	inputting_character = null
	reset_selections()
	return result
