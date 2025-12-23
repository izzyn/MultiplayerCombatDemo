extends Resource
class_name Stat

signal value_changed(new)

@export
var value : float = 100:
	set(new): 
		if value != new:
			value_changed.emit(new)
		value = new

@export
var default : float = 100

@export
var mod : float = 1.0
