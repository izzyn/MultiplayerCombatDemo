extends Node
class_name CharacterAgent

@export
var controller : CharacterController

@export
var data : CharacterData

@export
var linked_sprite : CharacterSpriteBase 

var last_selected : int

var rng = RandomNumberGenerator.new()
var intent_attack : AttackData
var intent_targets : Array[CharacterData] = []
var intent_arrows : Array[Node3D] = []

var death_delta : float = 0
