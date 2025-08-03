extends State

@export var encounter_setup_state: State
@export var run_results_state: State

func enter():
	%Status.text = "Alas, all of our heroes have perished..."
	%StatusContainer.visible = true
	
func exit():
	%StatusContainer.visible = false
	
func process(_delta: float) -> State:
	if time_active < 5:
		return null
	
	return run_results_state
