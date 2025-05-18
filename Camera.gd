extends Camera3D

var target : Node3D
var base_rotation = rotation
@onready
var base_position = global_position
func _process(delta: float) -> void:
	#if target:
	#	var target_vector = base_position.direction_to(target.global_position)
	#	var target_basis= Basis.looking_at(target_vector)
	#	print(base_position.distance_to(target.global_position))
	#	fov = lerpf(fov, (3*base_position.distance_to(target.global_position) - 30), delta)
	#	basis = basis.slerp(target_basis, 0.5)
	#	position = base_position

	
	pass
