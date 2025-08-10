extends State

@export var encounter_setup_state: State
@export var run_results_state: State

var _has_advanced_dialogue := false

@onready var ui_manager: UIManager = %UI

func enter():
	Globals.dialogue_completed.connect(on_dialogue_completed)
	_has_advanced_dialogue = false
	ui_manager.queue_message("Alas, all of our heroes have perished...", 5)

func exit():
	Globals.dialogue_completed.disconnect(on_dialogue_completed)

func process(_delta: float) -> State:
	if !_has_advanced_dialogue:
		return null
	
	return run_results_state

func on_dialogue_completed():
	_has_advanced_dialogue = true
