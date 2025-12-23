extends CharacterController
class_name PlayerController

func request_action(user : CharacterAgent, characters : Array[CharacterAgent]) -> CharacterAction:
	return await CombatSimulator.get_node("InputHandler").request_input(user, characters)
