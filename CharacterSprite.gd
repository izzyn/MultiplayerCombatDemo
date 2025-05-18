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

func _ready() -> void:
	print(character.hp)
	if flipped_text:
		get_node("UI").scale.x *= -1
	get_node("Node/SubViewport/VBoxContainer/PanelContainer/MarginContainer/Label").text = char_name
	pass
func _process(delta: float) -> void:
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
