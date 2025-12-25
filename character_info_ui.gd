extends Control

@export
var attack_containers : Array[VBoxContainer]

@export
var attack_container_limit : int

@export
var character_title_label : Label

@export
var status_container : VBoxContainer

@export
var health_bar : ProgressBar

@export
var character_icon : TextureRect

@export
var tracked_character : CharacterData


@export
var selected_box : StyleBoxFlat
@export
var unselected_box : StyleBoxFlat

func _process(delta: float) -> void:
	if tracked_character:
		health_bar.value = 100 * tracked_character.hp.value / tracked_character.hp.default
	pass
