class_name CharacterGroup extends Node

var characters: Array[Character] = []

func _ready():
	for node in get_children():
		if node is Character:
			characters.append(node)
			node.character_group = self
			
func add_character(character: Character):
	characters.append(character)
	character.character_group = self
	add_child(character)

func clear():
	var nodes = get_children()
	for node in nodes:
		remove_child(node)
		node.queue_free()
		
func any_alive():
	for character in characters:
		if not character.is_dead():
			return true
	return false
