extends Node

var turn : int
var turn_order : Array[CharacterAgent]

func start_simulation(participants : Array[CharacterAgent]):
	 
	for participant in participants: 
		participant.reparent(get_node("Participants"))
		
	while true:
		var local_participants: Array[CharacterAgent] = []
		for participant : CharacterAgent in get_node("Participants").get_children():
			local_participants.append(participant)
		if turn_order.size() == 0:
			for participant : CharacterAgent in get_node("Participants").get_children():
				turn_order.append(participant)
			turn_order.sort_custom(func(x,y): return x.data.speed.value < y.data.speed.value)
			turn += 1
		var actor = turn_order.pop_front()
		var action = await actor.controller.request_action(actor, local_participants)
		print(actor.controller is AIController)
		print(action)
		if action is ActionError:
			print("ERRROROROROR")
		print(action.user.controller is AIController)
		action.action.use_attack(action.user, action.targets)
	pass
