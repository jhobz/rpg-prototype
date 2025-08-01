extends State

@export var turn_state: State = null
@export var complete_state: State = null

var characters: Array[Character] = []
var current_actor: int = -1
var complete: bool = false

func enter():
	for node in %Characters.get_children():
		characters.append(node as Character if node is Character else node.get_node("Character") as Character)

func exit():
	characters.clear()

func process(_delta: float) -> State:
	# check if all PCs, or all NPCs, are dead
	var pc_alive = false
	var npc_alive = false
	for char in characters:
		if not char.is_dead():
			if char.is_player_character:
				pc_alive = true
			else:
				npc_alive = true
	
	if not pc_alive or not npc_alive:
		return complete_state
		
	# loop the character list (wrapping around) until we find the next not-dead character
	current_actor = wrapi(current_actor + 1, 0, characters.size())
	while characters[current_actor].is_dead():
		current_actor = wrapi(current_actor + 1, 0, characters.size())
	
	turn_state.character = characters[current_actor]
	return turn_state
