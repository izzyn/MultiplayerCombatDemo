extends Resource
class_name Status

@export
var id : String

var stacks:
	get():
		return len(_stack_sources)

var _stack_sources : Array[StackSource]

@export
var stackable : bool

@export
var modifiers : Array[Modifier]

@export
var additional_effect : Array[SecondaryEffect]

@export
var icon : Texture2D

@export
var tag_overrides : Array[Tag]

@export_category("Duration")

@export
var duration_on_turn : int

var duration_on_death : int

@export
var duration_on_hit : int
@export_subgroup("Stats")
