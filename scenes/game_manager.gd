class_name GameManager extends Node

@export var current_enemy: Character

@onready var actions: Node = %Actions
@onready var characters: Node = %Characters
@onready var state_machine: StateMachine = %GameStateMachine
@onready var john: Character = %Characters/JohnRPG
@onready var instructions_control: Control = %Instructions

var instructions: Array[Dictionary] = []
var executing_instruction: int = -1

func _ready() -> void:
	current_enemy = characters.get_node('Red Slime/Character')
	state_machine.init_state_machine()
	
func _process(delta: float):
	state_machine.process_state_machine(delta)

func log_instruction(action: Action, initiator: Character, target: Character) -> void:
	var instructions_list = instructions_control.get_node('PanelContainer/VBoxContainer/InstructionList')
	var instruction = {'action': action, 'initiator': initiator, 'target': target}
	instructions.append(instruction)
	instructions_list.add_item(instruction.initiator.char_name)
	instructions_list.add_item(instruction.action.name)
	instructions_list.add_item(instruction.target.char_name)

func _on_character_turn_turn_active(_character: Character):
	if executing_instruction == -1:
		return
	
	try_advance_playback()

func try_advance_playback():
	# skip instructions that are for characters who died
	while executing_instruction < instructions.size() and instructions[executing_instruction].initiator.is_dead():
		var skip_instruction = instructions[executing_instruction]
		print('skipping instruction because character is dead', skip_instruction.action, skip_instruction.initiator, skip_instruction.target)
		++executing_instruction
	
	# we're done if we pass the end of the list
	if executing_instruction >= instructions.size():
		print('done executing playback')
		executing_instruction = -1
		return
	
	# if the next instruction is for the character whose turn it is, do it
	# otherwise, sit there until that character's turn comes up
	if instructions[executing_instruction].initiator.is_turn_active:
		execute_instruction(instructions[executing_instruction])
		executing_instruction += 1

func execute_instruction(instruction: Dictionary):
	print('executing action', instruction.action, instruction.initiator, instruction.target)
	instruction.initiator.execute_action(instruction.action, instruction.target)

func _on_playback_button_pressed() -> void:
	if instructions.is_empty():
		print('nothing to play back!')
		return
	
	executing_instruction = 0
	try_advance_playback()

func _on_action_ui_component_action_selected(action: Action, source: Character) -> void:
	if not source.is_turn_active:
		return
	source.execute_action(action, current_enemy)
	log_instruction(action, source, current_enemy)
