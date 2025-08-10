extends State

@export var encounter_setup_state: State = null

var _has_advanced_dialogue := false

@onready var ui_manager: UIManager = %UI

func enter():
	Globals.dialogue_completed.connect(_on_dialogue_completed)
	_has_advanced_dialogue = false
	ui_manager.queue_message("You've defeated the enemies!", 2)

	if !Globals.save_state.has_cleared_first_encounter:
		Globals.save_state.has_cleared_first_encounter = true

func exit():
	Globals.dialogue_completed.disconnect(_on_dialogue_completed)
	
func process(_delta: float) -> State:
	if !_has_advanced_dialogue:
		return null

	return encounter_setup_state

func _on_dialogue_completed():
	_has_advanced_dialogue = true
