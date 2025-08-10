extends State

@export var encounter_setup_state: State = null

@onready var ui_manager: UIManager = %UI

func enter():
	ui_manager.show_message("You've defeated the enemies!")
	
func exit():
	ui_manager.hide_message()
	
func process(_delta: float) -> State:
	if time_active >= 2:
		return encounter_setup_state
	return null
