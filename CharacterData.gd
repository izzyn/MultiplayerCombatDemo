extends Resource
class_name CharacterData

@export_group("","")
@export
var id : String

@export
var name : String

@export
var team : bool

@export_group("Stats")
@export
var hp : Stat

@export
var normal_attack : Stat

@export
var magic_attack : Stat

@export
var normal_defence : Stat

@export
var magic_defence : Stat

@export
var speed : Stat

@export
var targetability_factor : float = 1

@export_group("AI Stats")
enum Playstyle {Buff, Debuff, Attack}
var playstyle : Playstyle

@export_group("","")
@export
var attacks : Array[AttackData]

var sprite : CharacterSprite

var _statuses : Array[Status]

signal _statuses_changed
