extends State

@export var turn_state: State = null
@export var battle_setup_state: State = null
@export var run_failed_state: State = null

@onready var players: CharacterGroup = %Characters/Players
@onready var enemies: CharacterGroup = %Characters/Enemies

var characters: Array[Character] = []
var current_actor: int = -1
var complete: bool = false

func init():
	characters.clear()
	characters.append_array(players.characters)
	characters.append_array(enemies.characters)

func reset_turn():
	current_actor = -1

func enter():
	pass

func exit():
	pass

func process(_delta: float) -> State:
	if not players.any_alive():
		return run_failed_state
	elif not enemies.any_alive():
		return battle_setup_state
		
	# loop the character list (wrapping around) until we find the next not-dead character
	current_actor = wrapi(current_actor + 1, 0, characters.size())
	while characters[current_actor].is_dead():
		current_actor = wrapi(current_actor + 1, 0, characters.size())
	
	turn_state.character = characters[current_actor]
	return turn_state
