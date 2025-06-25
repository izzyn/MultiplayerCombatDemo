extends Node

@export
var selected_box : StyleBoxFlat
@export
var unselected_box : StyleBoxFlat

var attack_target_list : Array[CharacterSprite] = []
var picked_targets : Array[CharacterSprite] 
var hovering_target : int = 0:
	set(value):
			var old = hovering_target
			hovering_target = value
			hovering_target_change(old)

var remaining_choices : int = 0

var selected : int = 0:
	set(value):
		if value != selected:
			interacting = false
		var old = selected
		selected = value
		if old != selected:
			selected_changed(old)

var selected_button : int = 0:
	set(value):
		var old = selected_button
		selected_button = value
		if old != selected_button:
			selected_button_changed(old)

var interacting : bool = false:
	set(value):
		var old = interacting
		interacting = value
		if old != interacting:
			interaction_changed(old)

@onready
var startUIpos = get_node("../Friendly").get_children()[0].get_node("UI").position

func _on_death():
	pass

func use_activated_attack():
	remaining_choices -= 1
	picked_targets.append(attack_target_list[hovering_target])
	var selected_node = attack_target_list[hovering_target]
	var actor = get_node("../Friendly").get_child(selected).character
	var attacks = actor.attacks
	var attack : AttackData = attacks[selected_button]
	if !attack.can_target_multiple_times:
		attack_target_list.erase(attack_target_list[hovering_target])
	if remaining_choices and attack_target_list.size():
		var selection = preload("res://Selection.tscn").instantiate()
		get_node("../Selections").add_child(selection)
		selection.position = selected_node.global_position
		hovering_target = 0
	if remaining_choices == 0:
		var characters : Array[CharacterData] = []
		for target in picked_targets:
			characters.append(target.character)
		attack.use_attack(actor, characters)
		set_cooldown()
		reset_choices()
	pass
func set_cooldown():
	var selected_sprite = get_node("../Friendly").get_child(selected)
	var data = selected_sprite.character
	selected_sprite.last_max_cooldown = data.attacks[selected_button].cooldown / (sqrt(data.speed.value/100))
	selected_sprite.cooldown = selected_sprite.last_max_cooldown
func reset_choices():
	get_node("../Selection").visible = false
	for child in get_node("../Selections").get_children():
		child.queue_free()
	attack_target_list.clear()
	picked_targets.clear()
	remaining_choices = 0
	hovering_target = 0
	pass
func hovering_target_change(old):
	if remaining_choices:
		get_node("../Selection").visible = true
		get_node("../Selection").target = attack_target_list[hovering_target]
	pass
func activate_attack():
	var actor = get_node("../Friendly").get_child(selected).character
	var attacks = actor.attacks
	var attack : AttackData = attacks[selected_button]
	var all_data = get_parent().get_all_characters()
	var all_sprites = get_parent().get_all_sprites()
	var filter_chars = attack.target_filter.eval(actor, all_data)
	if len(filter_chars) == 0: 
		return
	attack_target_list.clear()
	attack_target_list.append_array(all_sprites.filter(func(x): return x.character in filter_chars))
	remaining_choices = attack.target_amount
	if attack.hits_all:
		for i in attack_target_list:
			picked_targets.append(i)
			var selection = preload("res://Selection.tscn").instantiate()
			get_node("../Selections").add_child(selection)
			selection.position = i.global_position
		remaining_choices = 1
	else:
		get_node("../Selection").visible = true
		get_node("../Selection").position = attack_target_list[hovering_target].global_position
		get_node("../Selection").target = attack_target_list[hovering_target]
	pass
func selected_button_changed(old):
	var attacks = get_node("../Friendly").get_child(selected).character.attacks
	var nodes = get_node("../Friendly").get_child(selected).get_node("Node/SubViewport/VBoxContainer/Attacks")
	for attack in nodes.get_children():
		if selected_button == attack.actual_index:
			attack.get_node("HBoxContainer/ColorRect").visible = true
		else:
			attack.get_node("HBoxContainer/ColorRect").visible = false
	pass
func interaction_changed(old):
	var node = get_node("../Friendly").get_children()[selected].get_node("Node/SubViewport/VBoxContainer/Attacks")
	var charnode : CharacterSprite = get_node("../Friendly").get_children()[selected]
	for attack in node.get_children():
		attack.queue_free()
	if interacting:
		selected_button = 0
		for attack in range(charnode.character.attacks.size()):
			var instance = preload("res://attack_button.tscn").instantiate()
			instance.visible = false
			instance.get_node("HBoxContainer/Attack_Name").text = charnode.character.attacks[attack].name
			instance.actual_index = attack
			node.add_child(instance)
			node.move_child(instance, 0)
			selected_button_changed(0)
			instance.get_node("AnimationPlayer").play("Appear")
			await get_tree().create_timer(0.2).timeout
	pass
func selected_changed(old : int):
	if !remaining_choices and get_node("../Friendly").get_child(selected).character.hp.value == 0:
		selected = (selected+1)%get_node("../Friendly").get_children().size()
		
	var node = get_node("../Friendly")
	for child in range(node.get_children().size()):
		var current = get_node("../Friendly").get_children()[child].get_node("UI")
		if child == selected:
			current.get_node("AnimationPlayer").play("Scale")
		elif child == old:
			current.get_node("AnimationPlayer").play_backwards("Scale")
	get_node("../Camera3D").target =get_node("../Friendly").get_child(selected)
	pass
func _process(delta: float) -> void:
	
	pass
func _input(event: InputEvent) -> void:
	var attacks_length = get_node("../Friendly").get_child(selected).character.attacks.size()
	if event.is_action_pressed("NavigateUp"):
		if remaining_choices:
			hovering_target = (hovering_target+1) % attack_target_list.size()
		else:
			if interacting:
				if selected_button != 0:
					selected_button = (selected_button-1) % attacks_length
				else:
					selected_button = attacks_length - 1
				
			else:
				selected = (selected+1) % 4
	if event.is_action_pressed("NavigateDown"):
		if remaining_choices:
			if hovering_target == 0:
				hovering_target = attack_target_list.size()-1
			else:
				hovering_target = (hovering_target-1) % attack_target_list.size()
		else:
			if interacting:
				selected_button = (selected_button+1) % attacks_length
			else:
				if selected == 0:
					selected = 3
				else:
					selected = (selected-1) % 4
	if event.is_action_pressed("Confirm"):
		if remaining_choices:
			use_activated_attack()
		else:
			if interacting and get_node("../Friendly").get_child(selected).cooldown <= 0:
				activate_attack()
			else:
				interacting = true
	if event.is_action_pressed("Escape"):
		if remaining_choices:
			reset_choices()
		else:
			interacting = false
	pass
