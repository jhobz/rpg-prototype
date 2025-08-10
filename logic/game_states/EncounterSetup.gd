extends State

@export var run: Run = preload("res://data/Runs/basic_run.tres")
@export var battle_setup_state: State = null
@export var run_complete_state: State = null

signal encounter_started()

var _current_encounter := 0
var _has_advanced_dialogue := false

@onready var ui_manager: UIManager = %UI

func init():
	ui_manager.set_instructions_input_enabled(false)
	_current_encounter = 0

func enter():
	Globals.dialogue_completed.connect(_on_dialogue_completed)

	if _current_encounter == 0 or _current_encounter < run.encounters.size():
		encounter_started.emit()

	if _current_encounter == 0:
		_has_advanced_dialogue = false
		ui_manager.queue_message("Our heroes' journey begins!", 2)
		for character in CharacterManager.player_characters:
			character.refill_hp()
			character.visible = true
	elif _current_encounter < run.encounters.size():
		_has_advanced_dialogue = false
		ui_manager.queue_message("More enemies have been spotted!", 2)

func exit():
	Globals.dialogue_completed.disconnect(_on_dialogue_completed)

func process(_delta: float) -> State:
	if _current_encounter >= run.encounters.size():
		return run_complete_state

	if !_has_advanced_dialogue:
		return null

	battle_setup_state.init(run.encounters[_current_encounter])
	_current_encounter += 1
	return battle_setup_state

func _on_dialogue_completed():
	_has_advanced_dialogue = true
