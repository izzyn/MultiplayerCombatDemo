extends Node

@export_category("Characters")
@export
var characters : Dictionary[String, CharacterData]

@export
var enemies : Dictionary[String, CharacterData]


@export_category("Attacks & Statuses")
@export
var attacks : Dictionary[String, AttackData]

@export
var statuses : Dictionary[String, Status]
