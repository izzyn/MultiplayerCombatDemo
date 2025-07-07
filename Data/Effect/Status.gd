extends Resource
class_name Status

@export
var id : String

@export
var stacks : int = 1

@export
var stackable : bool

@export
var modifiers : Array[Modifier]

@export
var additional_effect : Array[SecondaryEffect]

@export
var icon : Texture2D
