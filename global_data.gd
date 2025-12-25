extends Node

@export_category("Characters")
@export
var characters : Dictionary[String, CharacterData]

@export
var enemies : Dictionary[String, CharacterData]

func fetch_attack(path : String) -> AttackData:
	return load("res://Resources/Attacks/" + path + ".tres")

func fetch_status(path : String) -> Status:
	return load("res://Resources/Statuses/" + path + ".tres")
