extends CharacterSpriteBase
class_name CharacterSprite

@export
var flipped_text : bool

var selections : Array[Node3D]
@export_group("Screen Shake")
@export
var start_ui_shake_strength : float = 50
var _shake_strength : float = 0
@export
var shake_fade_time : float = 5
var oldhp = -1

@onready
var moving_selection = get_parent().get_parent().get_node("Selection")

func attack_target_selected():
	var selection = preload("res://Selection.tscn").instantiate()
	get_parent().get_parent().get_node("Selections").add_child(selection)
	selection.position = global_position
	selection.target = self
	selections.append(selection)

func attack_target_deselected():
	selections[0].queue_free()
	selections.remove_at(0)
pass

func attack_target_focused():
	moving_selection.visible = true
	moving_selection.target = self
pass

func character_focused():
	moving_selection.visible = true
	moving_selection.target = self
pass

func character_defocused():
	moving_selection.visible = false
pass

func attack_target_defocused():
	moving_selection.visible = false
	pass

func attack_index_changed(old : int, new_index : int):
	var ui_info = get_parent().get_parent().get_node("CanvasLayer/CharacterInfo")
	var container1 = ui_info.attack_containers[floor(old / ui_info.attack_container_limit)]
	for i in container1.get_children():
		if i.actual_index == old:
			i.get_node("HBoxContainer/ColorRect").visible = false
	var container2 = ui_info.attack_containers[floor(old / ui_info.attack_container_limit)]
	for i in container2.get_children():
		if i.actual_index == new_index:
			i.get_node("HBoxContainer/ColorRect").visible = true
	pass

func character_selected():
	get_node("UI/AnimationPlayer").play("Scale")
	var attack_ui = get_node("Node/SubViewport/VBoxContainer/Attacks")
	var ui_info = get_parent().get_parent().get_node("CanvasLayer/CharacterInfo")
	ui_info.visible = true
	for attack in range(character_agent.data.attack_ids.size()):
			var instance = preload("res://UI/attack_button.tscn").instantiate()
			instance.visible = false
			instance.get_node("HBoxContainer/Attack_Name").text = GlobalData.fetch_attack(character_agent.data.attack_ids[attack]).name
			instance.actual_index = attack
			if attack == 0:
				instance.get_node("HBoxContainer/ColorRect").visible = true
			var container = ui_info.attack_containers[floor(attack / ui_info.attack_container_limit)]
			container.add_child(instance)
			#container.move_child(instance, 0)
			instance.get_node("AnimationPlayer").play("Appear")
			await get_tree().create_timer(0.2).timeout
	pass

func character_deselected():
	get_node("UI/AnimationPlayer").play_backwards("Scale")
	var ui_info = get_parent().get_parent().get_node("CanvasLayer/CharacterInfo")
	ui_info.visible = false
	for container in ui_info.attack_containers:
		for child in container.get_children():
			child.queue_free()
	pass

func _ready() -> void:
	if flipped_text:
		get_node("UI").scale.x *= -1
	get_node("Node/SubViewport/VBoxContainer/PanelContainer/MarginContainer/Label").text = character_agent.data.name
	character_agent.data._statuses_changed.connect(update_statuses)
	pass

func update_statuses():
	var status_box = get_node("Node/SubViewport/VBoxContainer/DebuffContainer")
	for child in status_box.get_children():
		child.queue_free()
	for status in character_agent.data._statuses:
		var status_ui = preload("res://DebuffUI.tscn").instantiate()
		status_ui.get_node("Label").text = str(status.stacks) + "x"
		status_ui.texture = status.icon
		status_box.add_child(status_ui)
	pass

func _process(delta: float) -> void:
	if character_agent.data.hp.value == 0:
		var node3d : Sprite3D = get_node("Sprite3D4")
		node3d.rotation.y = lerpf(node3d.rotation.y,PI*10,delta)
		if node3d.rotation.y > PI*8:
			visible = false
		#node3d.material_override.set_shader_parameter("enable_effect", true)
		#death_delta += delta
		#node3d.material_override.set_shader_parameter("time", death_delta)
		#if death_delta > 3:
		#	node3d.visible = false
	if oldhp == -1:
		oldhp=character_agent.data.hp.value
	if oldhp != character_agent.data.hp.value:
		_shake_strength = start_ui_shake_strength
	oldhp = character_agent.data.hp.value
	if _shake_strength > 0:
		_shake_strength = lerpf(_shake_strength,0,delta*shake_fade_time)
		get_node("UI").offset = get_random_offset()
	if character_agent:
		var hpbar : ProgressBar= get_node("Node/SubViewport/VBoxContainer/HPBar")
		hpbar.value = lerpf(hpbar.value, 100 * character_agent.data.hp.value/character_agent.data.hp.default, delta * shake_fade_time)
	pass

func get_random_offset():
	return Vector2(randf_range(-_shake_strength, _shake_strength), randf_range(-_shake_strength,_shake_strength))
