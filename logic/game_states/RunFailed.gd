extends State

@export var encounter_setup_state: State
@export var run_results_state: State
@onready var ui_manager: UIManager = %UI

func enter():
	ui_manager.show_message("Alas, all of our heroes have perished...")

func exit():
	ui_manager.hide_message()

func process(_delta: float) -> State:
	if time_active < 5:
		return null
	
	return run_results_state
