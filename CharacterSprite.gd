extends Node3D
class_name CharacterSprite

@export
var character : CharacterData

@export
var flipped_text : bool
@export
var AI_Controlled : bool

var last_selected : int

@export_group("Screen Shake")
@export
var start_ui_shake_strength : float = 50
var _shake_strength : float = 0
@export
var shake_fade_time : float = 5
var oldhp = -1

var last_max_cooldown : float = 3
var intent_cooldown : float = 0
var cooldown : float = 3
var rng = RandomNumberGenerator.new()
# INTENT
var intent_attack : AttackData
var intent_targets : Array[CharacterData] = []
var intent_arrows : Array[Node3D] = []

var death_delta : float = 0


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
	if len(possible_targets) == 0:
		cooldown += 1
		intent_cooldown = 1
	for targets_left in range(min(picked_attack.target_amount, len(possible_targets))):
		var highest_weight_target = -1
		var picked_target : CharacterData
		var weight_list = []
		for target in possible_targets:
			#Ensures the enemy tries to not kill itself or its allies :p
			var hostility_factor = 1
			if target.team != character.team and picked_attack.type == picked_attack.Type.Buff:
				hostility_factor = 0.01
			elif target.team == character.team and picked_attack.type != picked_attack.Type.Buff:
				hostility_factor = 0.01
			var weight = target.targetability_factor * hostility_factor
			weight_list.append([weight, target])
		intent_targets.append(Helper.random_list_get(weight_list))
		if !picked_attack.can_target_multiple_times:
			possible_targets.erase(picked_target)
		
	pass

func _get_weights():
	pass

func _ready() -> void:
	if flipped_text:
		get_node("UI").scale.x *= -1
	get_node("Node/SubViewport/VBoxContainer/PanelContainer/MarginContainer/Label").text = character.name
	character._statuses_changed.connect(update_statuses)
	pass

func update_statuses():
	var status_box = get_node("Node/SubViewport/VBoxContainer/DebuffContainer")
	for child in status_box.get_children():
		child.queue_free()
	for status in character._statuses:
		var status_ui = preload("res://DebuffUI.tscn").instantiate()
		status_ui.get_node("Label").text = str(status.stacks) + "x"
		status_ui.texture = status.icon
		status_box.add_child(status_ui)
	pass

func reset_attack():
	intent_attack = null
	for i in intent_arrows:
		i.queue_free()
	intent_arrows.clear()
		
	intent_targets.clear()
	pass
func _process(delta: float) -> void:
	if character.hp.value == 0:
		var node3d : Sprite3D = get_node("Sprite3D4")
		node3d.rotation.y = lerpf(node3d.rotation.y,PI*10,delta)
		reset_attack()
		if node3d.rotation.y > PI*8:
			visible = false
		#node3d.material_override.set_shader_parameter("enable_effect", true)
		#death_delta += delta
		#node3d.material_override.set_shader_parameter("time", death_delta)
		#if death_delta > 3:
		#	node3d.visible = false
		
	if intent_targets.size() == 0 and character and AI_Controlled and character.hp.value != 0 and intent_cooldown <= 0:
		_get_intent()
	elif intent_targets.size() != 0 and cooldown <= 0 and AI_Controlled:
		intent_attack.use_attack(character, intent_targets, self)
		last_max_cooldown = intent_attack.cooldown
		cooldown = last_max_cooldown
		reset_attack()
	if !intent_arrows.size() and intent_targets.size() and cooldown <= 3:
		for target in intent_targets:
			var friendly = get_node("../../Friendly").get_children()
			var sprite = null
			for friend in friendly:
				if friend.character == target:
					sprite = friend
			if sprite == null:
				break
			var node = preload("res://Data/targeting_arrow.tscn").instantiate()
			node.total_time = 3
			node.target = sprite
			get_parent().get_parent().add_child(node)
			node.get_node("Start").global_position = global_position
			node.get_node("End").global_position = global_position
			node.start_pos = global_position
			node.get_node("Start2").global_position = global_position
			intent_arrows.append(node)
	intent_cooldown -= delta
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
