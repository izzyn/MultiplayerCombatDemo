extends Node3D
class_name CharacterSprite

@export
var character : CharacterData

@export
var flipped_text : bool
@export
var AI_Controlled : bool

var last_selected : int
@export
var char_name : String
@export_group("Screen Shake")
@export
var start_ui_shake_strength : float = 50
var _shake_strength : float = 0
@export
var shake_fade_time : float = 5
var oldhp = -1

var last_max_cooldown : float = 2

var cooldown : float = 2
var rng = RandomNumberGenerator.new()
# INTENT
var intent_attack : AttackData
var intent_targets : Array[CharacterData] = []

func _get_intent():
	var highest_weight = -1
	var picked_attack : AttackData
	for i in character.attacks:
		var type_mult = 1
		if character.playstyle == character.Playstyle.Attack:
			if i.type == i.Type.Attack:
				type_mult = 2
			if i.type == i.Type.Debuff:
				type_mult = 1.5
		elif character.playstyle == character.Playstyle.Buff:
			if i.type == i.Type.Buff:
				type_mult = 2
			if i.type == i.Type.Debuff:
				type_mult = 1.5
		elif character.playstyle == character.Playstyle.Debuff:
			if i.type == i.Type.Debuff:
				type_mult = 2
			if i.type == i.Type.Attack:
				type_mult = 1.5
		var weight = i.base_ai_weight * type_mult * rng.randf_range(1,1.5) / i.cooldown
		
		if weight > highest_weight:
			highest_weight = weight
			picked_attack = i
	intent_attack = picked_attack
	var all_characters = get_parent().get_parent().get_all_characters()
	var possible_targets : Array[CharacterData] = []
	if picked_attack.target_filter:
		possible_targets = picked_attack.target_filter.eval(character, all_characters)
	else:
		possible_targets = all_characters
	if picked_attack.hits_all:
		intent_targets = possible_targets
		pass
	for taregets_left in range(picked_attack.target_amount):
		var highest_weight_target = -1
		var picked_target : CharacterData
		for target in possible_targets:
			#Ensures the enemy tries to not kill itself or its allies :p
			var hostility_factor = 1
			if target.team != character.team and picked_attack.type == picked_attack.Type.Buff:
				hostility_factor = 0.01
			elif target.team == character.team and picked_attack.type != picked_attack.Type.Buff:
				hostility_factor = 0.01
			var weight = target.targetability_factor * rng.randf_range(1,1.5) * hostility_factor
			if weight > highest_weight_target:
				highest_weight_target = weight
				picked_target = target
		intent_targets.append(picked_target)
		if !picked_attack.can_target_multiple_times:
			possible_targets.erase(picked_target)
		
	pass

func _get_weights():
	pass
func _ready() -> void:
	print(character.hp)
	if flipped_text:
		get_node("UI").scale.x *= -1
	get_node("Node/SubViewport/VBoxContainer/PanelContainer/MarginContainer/Label").text = char_name
	pass

func _process(delta: float) -> void:
	if intent_targets.size() == 0 and character and AI_Controlled:
		_get_intent()
	elif intent_targets.size() != 0 and cooldown <= 0 and AI_Controlled:
		intent_attack.use_attack(character, intent_targets)
		last_max_cooldown = intent_attack.cooldown
		cooldown = last_max_cooldown
	cooldown -= delta
	if oldhp == -1:
		oldhp=character.hp.value
	if oldhp != character.hp.value:
		_shake_strength = start_ui_shake_strength
	oldhp = character.hp.value
	if _shake_strength > 0:
		_shake_strength = lerpf(_shake_strength,0,delta*shake_fade_time)
		get_node("UI").offset = get_random_offset()
	if character:
		var hpbar : ProgressBar= get_node("Node/SubViewport/VBoxContainer/HPBar")
		hpbar.value = lerpf(hpbar.value, 100 * character.hp.value/character.hp.default, delta * shake_fade_time )
		var timebar : ProgressBar = get_node("Node/SubViewport/VBoxContainer/Timebar")
		timebar.value = 100 * cooldown / last_max_cooldown
		
	pass

func get_random_offset():
	return Vector2(randf_range(-_shake_strength, _shake_strength), randf_range(-_shake_strength,_shake_strength))
	pass
