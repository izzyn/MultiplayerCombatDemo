extends Node3D

func get_all_sprites() -> Array[CharacterSprite]:
	var all_sprites : Array[CharacterSprite] = []
	for i in get_node("Friendly").get_children():
		all_sprites.append(i)
	for i in get_node("Enemy").get_children():
		all_sprites.append(i)
	
	return all_sprites
	pass
func get_all_characters() -> Array[CharacterData]:
	var all_data : Array[CharacterData] = [] 
	for i in get_all_sprites():
		all_data.append(i.character)
	return all_data
	pass
