extends State

@export var turn_inactive_state: State

@onready var game_manager: GameManager = %GameManager

func enter() -> void:
	super.enter()

func exit() -> void:
	super.exit()

func process(_delta: float) -> State:
	game_manager.current_character.is_turn_active = false
	game_manager.current_character.is_turn_complete = true
	return turn_inactive_state
