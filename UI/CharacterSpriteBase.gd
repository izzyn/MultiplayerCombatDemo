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

func focus_changed(new_focus : CharacterAgent):
	pass

func defocused():
	pass

func attack_focused():
	pass

func attack_focus_changed(new_focus : CharacterAgent):
	pass

func attack_defocused():
	pass

func attack_selected():
	pass

func attack_deselected():
	pass
