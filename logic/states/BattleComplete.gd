extends State

func enter():
	print("It's all over!")
	
	var pc_alive = false
	var npc_alive = false

	for node in %Characters.get_children():
		var character = (node as Character) if node is Character else node.get_node("Character") as Character
		if not character.is_dead:
			if character.is_player_character:
				pc_alive = true
			else:
				npc_alive = true
	
	if pc_alive:
		print("The player wins!")
	else:
		print("The enemies win!")
	
func exit():
	pass

func process(_delta: float) -> State:
	return null
