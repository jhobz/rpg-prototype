extends State

@export var encounter_setup_state: State = null

func enter():
	%Status.text = "You've defeated the enemies!"
	%Status.visible = true
	
func exit():
	%Status.visible = false
	
func process(_delta: float) -> State:
	if time_active >= 2:
		return encounter_setup_state
	return null
