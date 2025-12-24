extends Node
class_name TurnTimer
var start_turn : int

var end_turn : int

signal timeout()
func _ready() -> void:
	CombatSimulator.turn_changed.connect(check_timeout)
	pass

func check_timeout(turn : int):
	if turn == end_turn:
		timeout.emit()
		queue_free()
	pass
