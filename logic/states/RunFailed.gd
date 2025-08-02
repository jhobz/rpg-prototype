extends State

@export var encounter_setup_state: State = null

func enter():
	%Status.text = "Alas, all of our heroes have perished..."
	%Status.visible = true
	
func exit():
	%Status.visible = false
	
func process(_delta: float) -> State:
	if time_active < 5:
		return null
	encounter_setup_state.init()
	return encounter_setup_state
