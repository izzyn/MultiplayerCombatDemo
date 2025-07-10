extends MeshInstance3D

@export
var start : MeshInstance3D

@export
var end : MeshInstance3D
func _physics_process(delta: float) -> void:
	position = start.position.lerp(end.position, 0.5);
	scale.z = start.position.distance_to(end.position)
	rotation.y = atan((end.position.x - start.position.x)/(end.position.z - start.position.z))
	pass
