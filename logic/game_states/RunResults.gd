extends State

@export var encounter_setup_state: State = null

var _has_advanced_dialogue := false
var _ready_for_next_run := false

@onready var ui_manager: UIManager = %UI

func enter():
	Globals.dialogue_completed.connect(on_dialogue_completed)
	Globals.next_run_requested.connect(_on_next_run_requested)
	_has_advanced_dialogue = false
	ui_manager.queue_message("The party perished! But the adventure does not end there...\nUse the left panel to modify your moves and try again!")
	ui_manager.set_instructions_input_enabled(true)
	ui_manager.show_run_results()
	_ready_for_next_run = false

func exit():
	Globals.dialogue_completed.disconnect(on_dialogue_completed)
	Globals.next_run_requested.disconnect(_on_next_run_requested)
	ui_manager.hide_run_results()

func process(_delta: float) -> State:
	if !_ready_for_next_run or !_has_advanced_dialogue:
		return null

	encounter_setup_state.init()
	return encounter_setup_state

func on_dialogue_completed():
	_has_advanced_dialogue = true

func _on_next_run_requested() -> void:
	_ready_for_next_run = true
