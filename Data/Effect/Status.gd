extends Resource
class_name Status

@export
var id : String

var stacks:
	get():
		return len(_stack_sources)

@export
var _stack_sources : Array[int]

@export
var stackable : bool

@export
var modifiers : Array[Modifier]

@export
var additional_effect : Array[SecondaryEffect]

@export
var icon : Texture2D
