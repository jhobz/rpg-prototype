extends State

@export var encounter_setup_state: State = null

var ready_for_next_run := false

func enter():
	# %Status.text = "IT'S EDIT TIME, BABY!"
	# %Status.visible = true
	%RunResultsPanel.visible = true
	ready_for_next_run = false
	
func exit():
	%RunResultsPanel.visible = false
	
func process(_delta: float) -> State:
	if ready_for_next_run:
		encounter_setup_state.init()
		return encounter_setup_state

	return null


func _on_next_run_button_pressed() -> void:
	ready_for_next_run = true
	pass
