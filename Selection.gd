extends Node3D

var target : Node3D
@export
var move_speed : float
func _physics_process(delta: float) -> void:
	if target:
		position = position.lerp(target.global_position, delta * move_speed)
