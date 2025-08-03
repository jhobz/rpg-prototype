extends State

@export var encounter_setup_state: State = null

var ready_for_next_run := false

func enter():
	%Status.text = "The party perished! But the adventure does not end there...\nUse the left panel to modify your moves and try again!"
	%StatusContainer.size_flags_vertical = Control.SizeFlags.SIZE_FILL
	%StatusContainer.visible = true
	%Instructions.toggle_input(true)
	%RunResultsPanel.visible = true
	ready_for_next_run = false
	
func exit():
	%StatusContainer.visible = false
	%StatusContainer.size_flags_vertical = Control.SizeFlags.SIZE_SHRINK_BEGIN
	%RunResultsPanel.visible = false
	
func process(_delta: float) -> State:
	if ready_for_next_run:
		encounter_setup_state.init()
		return encounter_setup_state

	return null


func _on_next_run_button_pressed() -> void:
	ready_for_next_run = true
	pass
