extends Node

var turn : int
var turn_order : Array[CharacterAgent]

signal turn_changed(turn : int)

func start_simulation(participants : Array[CharacterAgent]):
	 
	for participant in participants: 
		participant.reparent(get_node("Participants"))
		turn_changed.connect(participant.data.turn_changed)
		
	while true:
		var local_participants: Array[CharacterAgent] = []
		for participant : CharacterAgent in get_node("Participants").get_children():
			local_participants.append(participant)
		if turn_order.size() == 0:
			for participant : CharacterAgent in get_node("Participants").get_children():
				turn_order.append(participant)
			turn_order.sort_custom(func(x,y): return x.data.speed.value < y.data.speed.value)
			turn += 1
			turn_changed.emit(turn)
		var actor = turn_order.pop_front()
		var action = await actor.controller.request_action(actor, local_participants)
		action.action.use_attack(action.user, action.targets)
	pass

func create_turn_timeout(duration : int) -> TurnTimer:
	var timer = TurnTimer.new()
	timer.start_turn = turn
	timer.end_turn = turn + duration
	add_child(timer)
	return timer
pass
