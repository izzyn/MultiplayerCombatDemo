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

var last_max_cooldown : float

var cooldown : float

# INTENT
var intent_attack : int = 0
var intent_targets : Array[CharacterSprite] = []

func _get_intent():
	var highest_weight = -1
	for i in character.attacks:
		var type_mult = 1
		if character.playstyle == character.Playstyle.Attack:
			if i.type == i.Type.Attack:
				type_mult = 2
			if i.type == i.Type.Debuff:
				type_mult = 1.5
			else:
				type_mult = 1
		elif character.playstyle == character.Playstyle.Buff:
			if i.type == i.Type.Buff:
				type_mult = 2
			if i.type == i.Type.Debuff:
				type_mult = 1.5
			else:
				type_mult = 1
		elif character.playstyle == character.Playstyle.Debuff:
			if i.type == i.Type.Debuff:
				type_mult = 2
			if i.type == i.Type.Attack:
				type_mult = 1.5
			else:
				type_mult = 1
		var weight = i.base_ai_weight * type_mult / i.cooldown
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
	if intent_targets.size() == 0 and character:
		_get_intent()
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
