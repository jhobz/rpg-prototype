extends Node

@onready var actions: Node = %Actions
@onready var characters: Node = %Characters
@onready var state_machine: StateMachine = %GameStateMachine
@onready var john: Character = %Characters/JohnRPG
@onready var instructions_control: Control = %Instructions

var instructions: Array[Dictionary] = []

func _ready() -> void:
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

func _on_attack_button_pressed() -> void:
	if not john.is_turn_active:
		return

	var attack = actions.get_node("Attack")
	var slime = characters.get_node("Slime/Character")

	# TODO: this allows the game to continue but doesn't prevent an error
	if (!attack or !john or !slime):
		return

	john.execute_action(attack, slime)
	attack.execute(john, slime)
	log_instruction(attack, john, slime)
	
func _on_attack_bottom_button_pressed() -> void:
	if not john.is_turn_active:
		return
	var attack = actions.get_node("Attack")
	var red_slime = characters.get_node("Red Slime/Character")

	# TODO: this allows the game to continue but doesn't prevent an error
	if (!attack or !john or !red_slime):
		return

	john.execute_action(attack, red_slime)
	log_instruction(attack, john, red_slime)

func _on_roll_button_pressed() -> void:
	if not john.is_turn_active:
		return
	var roll = actions.get_node("Roll")
	john.execute_action(roll, john)
	log_instruction(roll, john, john)

func _on_playback_button_pressed() -> void:
	if instructions.is_empty():
		print('nothing to play back!')
		return
	
	for instruction in instructions:
		print('about to execute', instruction.action, instruction.initiator, instruction.target)
		await get_tree().create_timer(1).timeout
		instruction.action.execute(instruction.initiator, instruction.target)
