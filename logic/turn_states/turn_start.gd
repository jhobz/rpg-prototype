extends State

@export var action_source_state: State

@onready var game_manager: GameManager = %GameManager

func enter() -> void:
	super.enter()
	game_manager.current_character.is_turn_active = true
	game_manager.current_character.is_turn_complete = false

func exit() -> void:
	super.exit()

func process(_delta: float) -> State:
	# waiting on user input unless in playback mode
	return
