@tool
extends MeshInstance3D

@export
var speed : float = 1
func _process(delta: float) -> void:
	rotation.y += delta * speed
	
	pass
