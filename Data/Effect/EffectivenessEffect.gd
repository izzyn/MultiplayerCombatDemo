extends Effect
class_name EffectivenessEffect

func enact(user : CharacterData, target : CharacterData):
	user._attack_effectiveness *= amount
	pass
