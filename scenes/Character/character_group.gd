class_name CharacterGroup extends Node

var characters: Array[Character] = []

func _ready():
	var is_player_character = false

	for node in get_children():
		if node is Character:
			characters.append(node)
			node.character_group = self

			if node is PlayerCharacter:
				is_player_character = true

	if is_player_character:
		CharacterManager.player_characters = characters
	else:
		CharacterManager.enemy_characters = characters
			
func add_character(character: Character):
	characters.append(character)
	character.character_group = self
	add_child(character)

func clear():
	for character in characters:
		remove_child(character)
		character.queue_free()
	characters.clear()

func any_alive():
	for character in characters:
		if not character.is_dead():
			return true
	return false
