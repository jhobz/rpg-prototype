extends State

func enter():
	print("It's all over!")
	
	var pc_alive = false
	var npc_alive = false
	for node in %Characters.get_children():
		var char = node as Character
		if not char.is_dead():
			if char.is_player_character:
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
