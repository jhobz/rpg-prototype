extends State

@export var encounter_setup_state: State = null

var ready_for_next_run := false

@onready var ui_manager: UIManager = %UI

func enter():
	ui_manager.set_message_position('center')
	ui_manager.show_message("The party perished! But the adventure does not end there...\nUse the left panel to modify your moves and try again!")
	ui_manager.set_instructions_input_enabled(true)
	ui_manager.show_run_results()
	ready_for_next_run = false
	Globals.next_run_requested.connect(_on_next_run_requested)

func exit():
	ui_manager.hide_message()
	ui_manager.hide_run_results()
	ui_manager.set_message_position('top')
	Globals.next_run_requested.disconnect(_on_next_run_requested)

func process(_delta: float) -> State:
	if ready_for_next_run:
		encounter_setup_state.init()
		return encounter_setup_state

	return null


func _on_next_run_requested() -> void:
	ready_for_next_run = true
