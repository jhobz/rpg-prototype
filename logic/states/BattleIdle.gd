extends State

@export var turn_state: State = null
@export var battle_setup_state: State = null
@export var run_failed_state: State = null

var characters: Array[Character] = []
var current_actor: int = -1
var complete: bool = false

func init():
	characters.clear()
	for node in %Characters/Players.get_children():
		characters.append(node as Character if node is Character else node.get_node("Character") as Character)
	for node in %Characters/Enemies.get_children():
		characters.append(node as Character if node is Character else node.get_node("Character") as Character)
	current_actor = -1

func enter():
	pass

func exit():
	pass

func process(_delta: float) -> State:
	# check if all PCs, or all NPCs, are dead
	var pc_alive = false
	var npc_alive = false
	for character in characters:
		if not character.is_dead():
			if character.is_player_character:
				pc_alive = true
			else:
				npc_alive = true
	
	if not pc_alive:
		return run_failed_state
	elif not npc_alive:
		return battle_setup_state
		
	# loop the character list (wrapping around) until we find the next not-dead character
	current_actor = wrapi(current_actor + 1, 0, characters.size())
	while characters[current_actor].is_dead():
		current_actor = wrapi(current_actor + 1, 0, characters.size())
	
	turn_state.character = characters[current_actor]
	return turn_state
