extends Node3D
class_name CharacterSpriteBase

@export
var character_agent : CharacterAgent

func character_died():
	pass

func character_revived():
	pass

func character_selected():
	pass

func character_deselected():
	pass

func character_focused():
	pass

func character_focus_changed(new_focus : CharacterAgent):
	pass

func character_defocused():
	pass

func attack_target_focused():
	pass

func attack_target_focus_changed(new_focus : CharacterAgent):
	pass

func attack_index_changed(old_index : int, new_index : int):
	pass

func attack_target_defocused():
	pass

func attack_target_selected():
	pass

func attack_target_deselected():
	pass

func stat_changed():
	pass
