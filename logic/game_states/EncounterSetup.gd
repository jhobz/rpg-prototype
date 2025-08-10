extends State

@export var run: Run = preload("res://data/Runs/basic_run.tres")
@export var battle_setup_state: State = null
@export var run_complete_state: State = null

signal encounter_started()

var current_encounter: int = 0

@onready var ui_manager: UIManager = %UI

func init():
	ui_manager.set_instructions_input_enabled(false)
	current_encounter = 0

func enter():
	if current_encounter == 0 or current_encounter < run.encounters.size():
		encounter_started.emit()

	if current_encounter == 0:
		ui_manager.show_message("Our heroes' journey begins!")
		for character in CharacterManager.player_characters:
			character.refill_hp()
			character.visible = true
	elif current_encounter < run.encounters.size():
		ui_manager.show_message("More enemies have been spotted!")

func exit():
	ui_manager.hide_message()
	
func process(_delta: float) -> State:
	if current_encounter >= run.encounters.size():
		return run_complete_state
		
	if time_active < 2:
		return null
		
	battle_setup_state.init(run.encounters[current_encounter])
	current_encounter += 1
	return battle_setup_state
