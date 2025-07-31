class_name StateMachine
extends Node

@export var starting_state: State
var current_state: State

func init_state_machine():
	change_state(starting_state)
	
func change_state(new_state: State):
	if current_state:
		current_state.exit()
		current_state.time_active = 0
		
	current_state = new_state
	current_state.enter()
	
func process_state_machine(delta: float):
	current_state.time_active += delta
	var new_state = current_state.process(delta)
	if new_state:
		change_state(new_state)
