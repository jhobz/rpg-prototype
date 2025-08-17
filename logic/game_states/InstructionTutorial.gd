extends State

@export var battle_idle_state: State = null

var _has_advanced_dialogue := false

@onready var ui_manager: UIManager = %UI

func enter() -> void:
	Globals.dialogue_completed.connect(_on_dialogue_completed)
	_has_advanced_dialogue = false
	ui_manager.toggle_instruction_list(true)
	DialogueManager.play_instruction_tutorial_dialogue()

func exit() -> void:
	Globals.save_state.has_seen_instruction_tutorial = true
	Globals.dialogue_completed.disconnect(_on_dialogue_completed)

func process(_delta: float) -> State:
	if !_has_advanced_dialogue:
		return null

	return battle_idle_state

func _on_dialogue_completed():
	_has_advanced_dialogue = true
