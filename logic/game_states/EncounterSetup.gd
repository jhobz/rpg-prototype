extends State

@export var run: Run = preload("res://data/Runs/basic_run.tres")
@export var battle_setup_state: State = null
@export var run_complete_state: State = null

signal encounter_started(encounter: Encounter)

var _current_encounter := 0
var _has_advanced_dialogue := false

@onready var ui_manager: UIManager = %UI

func init():
	ui_manager.set_instructions_input_enabled(false)
	_current_encounter = 0

func enter():
	if !Globals.save_state.current_run:
		Globals.save_state.current_run = run
	else:
		assert(Globals.save_state.current_run == run)

	if _current_encounter <= run.encounters.size():
		Globals.start_encounter(_current_encounter)
		if DialogueManager.play_encounter_dialogue(_current_encounter):
			Globals.dialogue_completed.connect(_on_dialogue_completed)
			_has_advanced_dialogue = false
		encounter_started.emit(run.encounters[_current_encounter])

	if _current_encounter == 0:
		for character in CharacterManager.player_characters:
			character.refill_hp()
			character.visible = true

func exit():
	pass

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
	Globals.dialogue_completed.disconnect(_on_dialogue_completed)
