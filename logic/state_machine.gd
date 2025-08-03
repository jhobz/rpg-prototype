class_name StateMachine
extends Node

@export var starting_state: State
var current_state: State

func init_state_machine():
	change_state(starting_state)
	
func change_state(new_state: State):
	if current_state:
		_exit_state()
	_enter_state(new_state)

func _enter_state(new_state: State):
	current_state = new_state
	current_state.is_active = true
	current_state.enter()

func _exit_state():
	current_state.exit()
	current_state.is_active = false
	current_state.time_active = 0
	
# TODO: this should prob just go off of _process() instead of needing to be called by GameManager?
func process_state_machine(delta: float):
	current_state.time_active += delta
	var new_state = current_state.process(delta)
	if new_state:
		change_state(new_state)
