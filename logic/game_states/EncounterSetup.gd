extends State

@export var run: Run = preload("res://data/Runs/basic_run.tres")

@export var battle_setup_state: State = null
@export var run_complete_state: State = null

var current_encounter: int = 0

func init():
	current_encounter = 0

func enter():
	if current_encounter == 0:
		%Status.text = "Our heroes' journey begins!"
		%Status.visible = true
	elif current_encounter < run.encounters.size():
		%Status.text = "More enemies have been spotted!"
		%Status.visible = true
	
func exit():
	%Status.visible = false
	
func process(_delta: float) -> State:
	if current_encounter >= run.encounters.size():
		return run_complete_state
		
	if time_active < 2:
		return null
		
	battle_setup_state.init(run.encounters[current_encounter])
	current_encounter += 1
	return battle_setup_state
