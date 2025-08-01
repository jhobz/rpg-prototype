extends State

@export var idle_state: State = null

var character: Character = null

func enter():
	print("It's " + character.char_name + "'s turn!")
	character.is_turn_active = true
	pass
	
func exit():
	character.is_turn_active = false
	character.is_turn_complete = false
	character = null

func process(_delta: float) -> State:
	if character.is_player_character:
		if character.is_turn_complete:
			return idle_state
	else:
		if time_active >= 1.0:
			return idle_state
	return null
