extends Node

func _ready() -> void:
	var participants : Array[CharacterAgent] = []
	for i in get_children():
		participants.append(i)
	CombatSimulator.start_simulation(participants)
	pass
