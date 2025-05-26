extends Node3D

var target : Node3D

@export
var total_time : float

@export
var current_time : float 

var start_pos : Vector3
func _physics_process(delta: float) -> void:
	var end = get_node("End")
	var end2 = get_node("End2")
	current_time += delta
	if total_time != 0:
		end.global_position = start_pos.lerp(target.global_position , current_time/total_time)
		end2.global_position = start_pos.lerp(target.global_position , min(current_time,total_time/6)/(total_time/6))
	pass
