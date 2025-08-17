extends State

@export var encounter_setup_state: State = null

var _was_shown_dialogue := false
var _has_advanced_dialogue := false
var _ready_for_next_run := false

@onready var ui_manager: UIManager = %UI

func enter():
	Globals.next_run_requested.connect(_on_next_run_requested)
	_was_shown_dialogue = false

	if DialogueManager.play_post_death_dialogue():
		Globals.dialogue_completed.connect(on_dialogue_completed)
		ui_manager._clear_run_results()
		_was_shown_dialogue = true
		_has_advanced_dialogue = false
	else:
		ui_manager.populate_run_results(Globals.save_state.current_run)

	ui_manager.set_instructions_input_enabled(true)
	ui_manager.show_run_results()
	_ready_for_next_run = false

func exit():
	if _was_shown_dialogue:
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
	Globals.save_state.has_seen_editing_tutorial = true
	ui_manager.populate_run_results(Globals.save_state.current_run)

func _on_next_run_requested() -> void:
	_ready_for_next_run = true
