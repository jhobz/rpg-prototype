extends State

@export var idle_state: State

# TODO: get this from GameManager and remove wherever it's getting set
var character: Character

signal turn_active(character: Character)
signal turn_complete(character: Character)

func enter():
	print("It's " + character.char_name + "'s turn!")
	turn_active.emit(character)
	
func exit():
	turn_complete.emit(character)
	character = null

func process(_delta: float) -> State:
	# if character.is_player_character:
	if character.is_turn_complete:
		return idle_state
	# else:
		# if time_active >= 1.0:
			# return idle_state
	return null
