class_name GameManager extends Node

@export var current_enemy: Character

@onready var actions: Node = %Actions
@onready var characters: Node = %Characters
@onready var state_machine: StateMachine = %GameStateMachine
@onready var john: Character = %Characters/JohnRPG
@onready var instructions_control: Control = %Instructions

var instructions: Array[Dictionary] = []

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

func _on_playback_button_pressed() -> void:
	if instructions.is_empty():
		print('nothing to play back!')
		return
	
	for instruction in instructions:
		print('about to execute', instruction.action, instruction.initiator, instruction.target)
		await get_tree().create_timer(1).timeout
		instruction.action.execute(instruction.initiator, instruction.target)


func _on_action_ui_component_action_selected(action: Action, source: Character) -> void:
	if not source.is_turn_active:
		return
	source.execute_action(action, current_enemy)
	log_instruction(action, source, current_enemy)
